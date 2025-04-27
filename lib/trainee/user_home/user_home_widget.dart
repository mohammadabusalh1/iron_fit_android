import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/services/notification_service.dart';
import 'package:iron_fit/utils/logger.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'user_home_model.dart';
import 'components/user_header.dart';
import 'components/today_info_section.dart';
import 'components/stats_section.dart';
import 'components/exercises_section.dart';
import 'components/app_message_card.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'user_home_model.dart';

class UserHomeWidget extends StatefulWidget {
  const UserHomeWidget({super.key});

  @override
  State<UserHomeWidget> createState() => _UserHomeWidgetState();
}

class _UserHomeWidgetState extends State<UserHomeWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final UserHomeModel _model;
  late final AnimationController _fadeInController;
  late final AnimationController _slideController;
  late final AnimationController _scaleController;
  final NotificationService _notificationService = NotificationService();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<double> _source = ValueNotifier<double>(100);

  // Memoized widgets to prevent rebuilds
  late final Widget _appMessageCardAnimated;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => UserHomeModel());

    _initializeControllers();
    _initializeNotifications();

    // Create memoized widgets
    _appMessageCardAnimated = _buildAppMessageCardAnimated();

    // Check for today's exercises and show weight update reminder
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _checkTodaysExercisesAndShowReminder();
      }
    });
  }

  Widget _buildAppMessageCardAnimated() {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(-100 * (1 - _slideController.value), 0),
          child: Opacity(
            opacity: _slideController.value,
            child: const AppMessageCard(),
          ),
        );
      },
    );
  }

  void _initializeControllers() {
    try {
      _fadeInController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

      _slideController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      _scaleController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          try {
            _fadeInController.forward();
          } catch (e) {
            Logger.error('Failed to start fade animation', e);
          }
        }
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          try {
            _slideController.forward();
          } catch (e) {
            Logger.error('Failed to start slide animation', e);
          }
        }
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          try {
            _scaleController.forward();
          } catch (e) {
            Logger.error('Failed to start scale animation', e);
          }
        }
      });

      Logger.debug('Animation controllers initialized successfully');
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize animation controllers', e, stackTrace);
    }
  }

  void _initializeNotifications() async {
    try {
      await _notificationService.initializeNotification();
      await getPlan();
      Logger.info('Notifications initialized successfully');
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize notifications', e, stackTrace);
    }
  }

  void _checkTodaysExercisesAndShowReminder() async {
    try {
      if (currentTraineeDocument == null) return;

      // Check if dialog was already shown today
      if (await _wasReminderShownToday()) {
        Logger.info('Weight reminder already shown today, skipping');
        return;
      }

      // Check if user has exercises today
      final subscriptionsQuery = await querySubscriptionsRecord(
        queryBuilder: (subscriptionsRecord) => subscriptionsRecord
            .where('trainee', isEqualTo: currentTraineeDocument!.reference)
            .where('isActive', isEqualTo: true),
        singleRecord: true,
      ).first;

      if (subscriptionsQuery.isEmpty || subscriptionsQuery.first.plan == null) {
        Logger.info('No active subscription found for weight reminder');
        return;
      }

      final plan =
          await PlansRecord.getDocument(subscriptionsQuery.first.plan!).first;

      // Check for today's exercises
      final todayExercises = _getTodayExercises(plan);

      if (todayExercises.isNotEmpty) {
        // Show reminder dialog after the animations finish
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              _showWeightUpdateBottomSheet();
              // Mark that we've shown the reminder today
              _markReminderShownToday();
            }
          });
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Failed to check for today\'s exercises', e, stackTrace);
    }
  }

  Future<bool> _wasReminderShownToday() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastShownDate = prefs.getString('weight_reminder_last_shown');

      if (lastShownDate == null) {
        return false;
      }

      final today = DateTime.now();
      final lastShown = DateTime.parse(lastShownDate);

      // Check if the reminder was shown on the same day
      return lastShown.year == today.year &&
          lastShown.month == today.month &&
          lastShown.day == today.day;
    } catch (e) {
      Logger.error('Error checking last reminder date', e);
      return false;
    }
  }

  Future<void> _markReminderShownToday() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String();
      await prefs.setString('weight_reminder_last_shown', today);
      Logger.info('Marked weight reminder as shown today');
    } catch (e) {
      Logger.error('Error marking reminder as shown', e);
    }
  }

  List<dynamic> _getTodayExercises(PlansRecord plan) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final dayMap = {
      1: ['Monday', 'الاثنين', 'الإثنين'],
      2: ['Tuesday', 'الثلاثاء'],
      3: ['Wednesday', 'الأربعاء', 'الاربعاء'],
      4: ['Thursday', 'الخميس'],
      5: ['Friday', 'الجمعة'],
      6: ['Saturday', 'السبت'],
      7: ['Sunday', 'الاحد', 'الأحد'],
    };

    final todayNames = dayMap[weekday] ?? [];
    final todayExercises = plan.plan.days
        .where((day) => todayNames.contains(day.day))
        .map((day) => day.exercises)
        .expand((exercises) => exercises)
        .toList();

    return todayExercises;
  }

  void _showWeightUpdateBottomSheet() {
    final TextEditingController weightController = TextEditingController(
      text: currentTraineeDocument!.weight.toString(),
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryText
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title and description with icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.fitness_center,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    FFLocalizations.of(context)
                                        .getText('weight_reminder_title'),
                                    style: AppStyles.textCairo(
                                      context,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    FFLocalizations.of(context)
                                        .getText('weight_reminder_message'),
                                    style: AppStyles.textCairo(
                                      context,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Modern weight selector
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                FFLocalizations.of(context)
                                    .getText('current_weight'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: 15,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Decrement button
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        int currentWeight = int.tryParse(
                                                weightController.text) ??
                                            60;
                                        if (currentWeight > 30) {
                                          HapticFeedback.lightImpact();
                                          weightController.text =
                                              (currentWeight - 1).toString();
                                          setState(() {});
                                        }
                                      },
                                      customBorder: const CircleBorder(),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.remove,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),

                                  // Weight display
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          TextFormField(
                                            controller: weightController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            style: AppStyles.textCairo(
                                              context,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return FFLocalizations.of(
                                                        context)
                                                    .getText(
                                                        'weightIsRequired');
                                              }
                                              final weight =
                                                  int.tryParse(value);
                                              if (weight == null ||
                                                  weight < 30 ||
                                                  weight > 300) {
                                                return FFLocalizations.of(
                                                        context)
                                                    .getText(
                                                        'invalid_weight_range');
                                              }
                                              return null;
                                            },
                                            onChanged: (_) => setState(() {}),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: Text(
                                              'kg',
                                              style: AppStyles.textCairo(
                                                context,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),

                                  // Increment button
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        int currentWeight = int.tryParse(
                                                weightController.text) ??
                                            60;
                                        if (currentWeight < 300) {
                                          HapticFeedback.lightImpact();
                                          weightController.text =
                                              (currentWeight + 1).toString();
                                          setState(() {});
                                        }
                                      },
                                      customBorder: const CircleBorder(),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Primary Action Button with Loader
                        ValueListenableBuilder<bool>(
                          valueListenable: isLoading,
                          builder: (context, loading, _) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).primary,
                                  foregroundColor: Colors.white,
                                  elevation: loading ? 0 : 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: loading
                                    ? null
                                    : () async {
                                        if (formKey.currentState!.validate()) {
                                          isLoading.value = true;
                                          HapticFeedback.mediumImpact();

                                          final weight = int.tryParse(
                                              weightController.text);
                                          if (weight != null) {
                                            try {
                                              // Create a new history entry
                                              final newWeightHistoryEntry = {
                                                'weight': weight,
                                                'date': DateTime.now()
                                                    .toIso8601String(), // Add a timestamp or any other relevant data
                                              };

                                              // Assuming currentTraineeDocument!.history is a List
                                              final updatedWeightHistory = List
                                                  .from(currentTraineeDocument!
                                                      .weightHistory)
                                                ..add(
                                                    newWeightHistoryEntry); // Push the new entry

                                              await currentTraineeDocument!
                                                  .reference
                                                  .update(
                                                createTraineeRecordData(
                                                  weight: weight,
                                                  weightHistory:
                                                      updatedWeightHistory, // Update the history with the new entry
                                                ),
                                              );
                                              Logger.info(
                                                  'Updated trainee weight to $weight kg');
                                              if (mounted) {
                                                Navigator.pop(context);
                                              }
                                            } catch (e) {
                                              Logger.error(
                                                  'Failed to update weight', e);
                                              isLoading.value = false;
                                            }
                                          }
                                        }
                                      },
                                child: loading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        FFLocalizations.of(context)
                                            .getText('update'),
                                        style: AppStyles.textCairo(
                                          context,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Dismiss Button
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              FFLocalizations.of(context).getText('skip'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: 15,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _model.dispose();
    _isLoading.dispose();
    _source.dispose();
    super.dispose();
  }

  Future<void> getPlan() async {
    if (currentTraineeDocument == null) return;
    try {
      if (!mounted) return;

      final subscriptionSnapshot = await querySubscriptionsRecord(
          queryBuilder: (subscriptionsRecord) => subscriptionsRecord.where(
              'trainee',
              isEqualTo: currentTraineeDocument!.reference)).first;

      if (subscriptionSnapshot.isEmpty) {
        Logger.warning(
            'No subscription found for trainee ${currentTraineeDocument!.reference.id}');
        return;
      }

      final plan =
          await PlansRecord.getDocument(subscriptionSnapshot.first.plan!).first;

      if (mounted) {
        _source.value = plan.plan.totalSource.toDouble();
        Logger.info(
            'Successfully retrieved plan with source: ${_source.value}');
      }
    } catch (e, stackTrace) {
      Logger.error('Failed to retrieve user plan', e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (FFAppState().userType != 'trainee') {
      Logger.warning('Non-trainee user attempting to access trainee home page');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('Login');
        }
      });
      return const LoadingIndicator();
    }
    if (currentUserReference == null) {
      Logger.warning(
          'Current user reference is null, showing loading indicator');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('Login');
        }
      });
      return const LoadingIndicator();
    }

    if (currentTraineeDocument == null) {
      Logger.warning(
          'current trainee document is null, showing loading indicator');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('Login');
        }
      });
      return const LoadingIndicator();
    }

    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            // Background gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.05),
                    FlutterFlowTheme.of(context).primaryBackground,
                  ],
                ),
              ),
            ),

            // Main content with refresh indicator and animations
            RefreshIndicator(
              onRefresh: () async {
                try {
                  _isLoading.value = true;
                  await getPlan();
                  Logger.info('Data refreshed successfully');
                } catch (e, stackTrace) {
                  Logger.error('Error refreshing data', e, stackTrace);
                } finally {
                  if (mounted) {
                    _isLoading.value = false;
                  }
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: AnimatedBuilder(
                  animation: _fadeInController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeInController.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _fadeInController.value)),
                        child: child!,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top),
                        UserHeader(
                          trainee: currentTraineeDocument!,
                          notificationService: _notificationService,
                        ),
                        TodayInfoSection(animation: _slideController),
                        StatsSection(
                          trainee: currentTraineeDocument!,
                          animation: _scaleController,
                          sourceNotifier: _source,
                        ),
                        ExercisesSection(
                          trainee: currentTraineeDocument!,
                          animation: _slideController,
                        ),
                        _appMessageCardAnimated,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Loading overlay
            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, _) {
                if (!isLoading) return const SizedBox.shrink();

                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: FlutterFlowTheme.of(context)
                        .black
                        .withValues(alpha: 0.3),
                    child: const Center(
                      child: LoadingIndicator(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ).withUserNavBar(0),
    );
  }
}
