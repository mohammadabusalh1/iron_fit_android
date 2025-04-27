import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iron_fit/coach/mesagess/mesagess_widget.dart';
import 'package:iron_fit/coach/subscription/subscriptions_widget.dart';
import 'package:iron_fit/coach/coach_settings/coach_settings_widget.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/pages/contact/contact_widget.dart';
import 'package:iron_fit/pages/error_page/error_page_widget.dart';
import 'package:iron_fit/coach/features/features_page.dart';
import 'package:iron_fit/pages/user_type/user_type_page.dart';
import 'package:iron_fit/trainee/settings/trainee_settings_widget.dart';
import 'package:iron_fit/trainee/subscription/subscription_widget.dart';
import 'package:iron_fit/dialogs/select_day_for_plan/select_day_for_plan_widget.dart';
import 'package:iron_fit/coach/coach_exercises_plans/plan_details/plan_details_page.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';

import '/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';
import '/auth/firebase_auth/auth_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  // bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    // Check if the user has actually changed to avoid unnecessary rebuilds
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;

    // Only update the user property if there's a change to avoid triggering rebuilds
    if (shouldUpdate) {
      user = newUser;
      // Refresh the app on auth change unless explicitly marked otherwise.
      if (notifyOnAuthChange) {
        notifyListeners();
      }
    }

    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    // Only notify listeners if splash image state actually changes
    if (showSplashImage) {
      showSplashImage = false;
      notifyListeners();
    }
  }
}

Widget _waitForAuthAndInitialize(BuildContext context) {
  // return UserEnterInfoWidget();
  // Use FutureBuilder to properly wait for authentication
  return FutureBuilder<void>(
    future: _waitForAuth(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: LoadingIndicator(),
        );
      }

      // return UserTypePage();

      // Store state in local variables to avoid multiple calls
      final appState = FFAppState();

      if (appState.isFirstTme) {
        return PreLoginWidget();
      } else if (appState.isLogined &&
          appState.userType != null &&
          currentUserReference != null) {
        return appState.userType == 'coach'
            ? const CoachHomeWidget()
            : const UserHomeWidget();
      } else {
        return const LoginWidget();
      }
    },
  );
}

Future<void> _waitForAuth() async {
  // Check every 100ms until authentication is available
  while (currentUserReference == null && FFAppState().isLogined) {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  if (FFAppState().userType == 'coach' && FFAppState().isLogined) {
    authenticatedCoachStream.listen((_) {});

    while (currentCoachDocument == null &&
        FFAppState().isLogined &&
        FFAppState().userType == 'coach') {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  } else if (FFAppState().userType == 'trainee' && FFAppState().isLogined) {
    authenticatedTraineeStream.listen((_) {});
    while (currentTraineeDocument == null &&
        FFAppState().isLogined &&
        FFAppState().userType == 'trainee') {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => const ErrorPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) {
            return _waitForAuthAndInitialize(context);
          },
        ),
        FFRoute(
          name: 'UserType',
          path: '/UserType',
          builder: (context, params) => const UserTypePage(),
        ),
        FFRoute(
          name: 'Subscription',
          path: '/Subscription',
          builder: (context, params) => const SubscriptionsWidget(),
        ),
        FFRoute(
          name: 'Login',
          path: '/login',
          builder: (context, params) => const LoginWidget(),
        ),
        FFRoute(
          name: 'Contact',
          path: '/Contact',
          builder: (context, params) => const ContactWidget(),
        ),
        FFRoute(
          name: 'UserHome',
          path: '/home1',
          builder: (context, params) => const UserHomeWidget(),
        ),
        FFRoute(
          name: 'SignUp',
          path: '/signUp',
          builder: (context, params) => const SignUpWidget(),
        ),
        FFRoute(
          name: 'PreLogin',
          path: '/preLogin',
          builder: (context, params) => PreLoginWidget(),
        ),
        FFRoute(
          name: 'days',
          path: '/days',
          builder: (context, params) => const DaysWidget(),
        ),
        FFRoute(
          name: 'userExercises',
          path: '/userExercises',
          builder: (context, params) => UserExercisesWidget(
            exercises: params.getParam<ExerciseStruct>(
              'exercises',
              ParamType.DataStruct,
              isList: true,
              structBuilder: ExerciseStruct.fromSerializableMap,
            ),
            maxProgress: params.getParam(
              'maxProgress',
              ParamType.int,
            ),
            day: params.getParam(
              'day',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: 'userProfile',
          path: '/userProfile',
          builder: (context, params) => const UserProfileWidget(),
        ),
        FFRoute(
          name: 'mySubscription',
          path: '/mySubscription',
          builder: (context, params) => const SubscriptionWidget(),
        ),
        FFRoute(
          name: 'CoachHome',
          path: '/coachHome',
          builder: (context, params) => const CoachHomeWidget(),
        ),
        FFRoute(
          name: 'AddClient',
          path: '/addClient',
          builder: (context, params) => const AddClientWidget(),
        ),
        FFRoute(
          name: 'CoachExercisesPlans',
          path: '/coachExercisesPlans',
          builder: (context, params) => const CoachExercisesPlansWidget(),
        ),
        FFRoute(
          name: 'createExercisePlan',
          path: '/createExercisePlan',
          builder: (context, params) => CreateExercisePlanWidget(
            exercises: params.getParam<ExerciseStruct>(
              'exercises',
              ParamType.DataStruct,
              isList: true,
              structBuilder: ExerciseStruct.fromSerializableMap,
            ),
            plan: params.getParam<PlanStruct>(
              'plan',
              ParamType.DataStruct,
              structBuilder: PlanStruct.fromSerializableMap,
            ),
            planRef: params.getParam(
              'planRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['plans'],
            ),
          ),
        ),
        FFRoute(
          name: 'coachAnalytics',
          path: '/coachAnalytics',
          builder: (context, params) => const CoachAnalyticsWidget(),
        ),
        FFRoute(
          name: 'coachFeatures',
          path: '/coachFeatures',
          builder: (context, params) => const FeaturesPage(),
        ),
        FFRoute(
          name: 'Mesagess',
          path: '/mesagess',
          builder: (context, params) => const MessagesWidget(),
        ),
        FFRoute(
          name: 'CoachProfile',
          path: '/coachProfile',
          builder: (context, params) => const CoachProfileWidget(),
        ),
        FFRoute(
          name: 'CoachEnterInfo',
          path: '/coachEnterInfo',
          builder: (context, params) => CoachEnterInfoWidget(
            isEditing: params.getParam<bool>(
              'isEditing',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: 'userEnterInfo',
          path: '/userEnterInfo',
          builder: (context, params) => const UserEnterInfoWidget(),
        ),
        FFRoute(
          name: 'NutritionPlans',
          path: '/nutritionPlans',
          builder: (context, params) => const NutritionPlansWidget(),
        ),
        FFRoute(
          name: 'CreateNutritionPlans',
          path: '/createNutritionPlans',
          builder: (context, params) => CreateNutritionPlansWidget(
            editNutPlan: params.getParam(
              'editNutPlan',
              ParamType.DataStruct,
              isList: false,
              structBuilder: NutPlanStruct.fromSerializableMap,
            ),
          ),
        ),
        FFRoute(
          name: 'SelectDayForPlan',
          path: '/selectDayForPlan',
          builder: (context, params) => SelectDayForPlan(
            existingDays: params.getParam<List<String>>(
                  'existingDays',
                  ParamType.String,
                  isList: true,
                ) ??
                [],
            editingDay: params.getParam<TrainingDayStruct>(
              'editingDay',
              ParamType.DataStruct,
              isList: false,
              structBuilder: TrainingDayStruct.fromSerializableMap,
            ),
          ),
        ),
        FFRoute(
          name: 'nutPlanDetials',
          path: '/nutPlanDetials',
          asyncParams: {
            'nuPlan': getDoc(['nutPlan'], NutPlanRecord.fromSnapshot),
          },
          builder: (context, params) => NutPlanDetialsWidget(
            nuPlan: params.getParam(
              'nuPlan',
              ParamType.Document,
            ),
            isForUser: false,
          ),
        ),
        FFRoute(
          name: 'nutPlanDetialsUser',
          path: '/nutPlanDetialsUser',
          asyncParams: {
            'nuPlan': getDoc(['nutPlan'], NutPlanRecord.fromSnapshot),
          },
          builder: (context, params) => NutPlanDetialsWidget(
            hasNav: true,
            nuPlan: params.getParam(
              'nuPlan',
              ParamType.Document,
            ),
            isForUser: true,
          ),
        ),
        FFRoute(
          name: 'trainees',
          path: '/trainees',
          builder: (context, params) => const TraineesWidget(),
        ),
        FFRoute(
          name: 'trainee',
          path: '/trainee',
          builder: (context, params) => TraineeWidget(
            sub: params.getParam(
              'sub',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['subscriptions'],
            ),
          ),
        ),
        FFRoute(
          name: 'traineeSettings',
          path: '/traineeSettings',
          builder: (context, params) => TraineeSettingsWidget(
            traineeRef: params.getParam(
              'trainee',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['trainee'],
            )!,
          ),
        ),
        FFRoute(
          name: 'CoachSettings',
          path: '/coachSettings',
          builder: (context, params) => const CoachSettingsWidget(),
        ),
        FFRoute(
          name: 'PlanDetails',
          path: '/planDetails',
          asyncParams: {
            'plan': getDoc(['plans'], PlansRecord.fromSnapshot),
          },
          builder: (context, params) {
            return PlanDetailsPage(
              plan: params.getParam(
                'plan',
                ParamType.Document,
                isList: false,
              ),
            );
          },
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/preLogin';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() =>
      const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
