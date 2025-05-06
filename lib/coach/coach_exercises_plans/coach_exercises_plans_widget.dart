import 'dart:async';

import 'package:iron_fit/Ad/AdService.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'coach_exercises_plans_model.dart';

import 'components/error_widget.dart';
import 'components/plans_header.dart';
import 'components/plans_section.dart';

// Static cache class for CoachExercisesPlans
class CoachExercisesPlansCache {
  static CoachRecord? cachedCoach;
  static List<PlansRecord>? cachedPlans;
  static DateTime? lastUpdated;
  static const Duration validDuration = Duration(minutes: 15);

  static bool get isValid {
    if (lastUpdated == null || cachedCoach == null) return false;
    return DateTime.now().difference(lastUpdated!) < validDuration;
  }

  static void update(CoachRecord coach, List<PlansRecord> plans) {
    cachedCoach = coach;
    cachedPlans = plans;
    lastUpdated = DateTime.now();
  }

  static Future<void> clear() async {
    cachedCoach = null;
    cachedPlans = null;
    lastUpdated = null;
  }
}

class CoachExercisesPlansWidget extends StatefulWidget {
  /// I want you to create coach plans page to show and create plans (workout)
  /// for trainee
  const CoachExercisesPlansWidget({super.key});

  @override
  State<CoachExercisesPlansWidget> createState() =>
      _CoachExercisesPlansWidgetState();
}

class _CoachExercisesPlansWidgetState extends State<CoachExercisesPlansWidget>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AdService _adService;
  late CoachExercisesPlansModel _model;
  final String _cacheKey = 'coach_plans_cache';
  final Duration _cacheDuration = const Duration(minutes: 15);
  DateTime? _lastFetchTime;
  bool _isMounted = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _model = createModel(context, () => CoachExercisesPlansModel());
    _tabController = TabController(length: 2, vsync: this);
    _adService = AdService();

    // Add delay to ad loading
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _adService.loadAd(context);
      }
    });
    _loadDataWithCache();
  }

  // Load data from cache first, then fetch from network if needed
  Future<void> _loadDataWithCache() async {
    if (!_isMounted) return;

    // Try to load from cache first
    final cachedData = await _loadFromCache();
    if (cachedData != null && _isMounted) {
      _updateModelWithCache(cachedData);
    }

    // Check if we need to fetch fresh data
    final shouldFetchFresh = _shouldFetchFreshData();
    if ((shouldFetchFresh || cachedData == null) && _isMounted) {
      await _loadData();
    }
  }

  // Determine whether fresh data should be fetched based on last fetch time
  bool _shouldFetchFreshData() {
    if (_lastFetchTime == null) return true;
    final now = DateTime.now();
    return now.difference(_lastFetchTime!) > _cacheDuration;
  }

  // Load data from cache
  Future<Map<String, dynamic>?> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString(_cacheKey);
      if (cachedString == null) return null;

      final cachedJson = jsonDecode(cachedString) as Map<String, dynamic>;
      final timestamp = cachedJson['timestamp'] as int;
      final fetchTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

      // Check if cache is still valid
      if (DateTime.now().difference(fetchTime) > _cacheDuration) {
        return null;
      }

      _lastFetchTime = fetchTime;
      return cachedJson;
    } catch (e) {
      return null;
    }
  }

  // Update model with cached data
  void _updateModelWithCache(Map<String, dynamic> cachedData) {
    if (!_isMounted) return;

    try {
      if (cachedData.containsKey('coach')) {
        final coachData = cachedData['coach'] as Map<String, dynamic>;
        // Create coach record from map data
        final coach = CoachRecord.getDocumentFromData(
          coachData,
          FirebaseFirestore.instance.doc(coachData['reference_path'] as String),
        );
        _model.updateCoach(coach);
      }

      if (cachedData.containsKey('plans')) {
        final plansDataList = cachedData['plans'] as List;
        final plans = plansDataList.map((planData) {
          final data = planData as Map<String, dynamic>;
          return PlansRecord.getDocumentFromData(
            data,
            FirebaseFirestore.instance.doc(data['reference_path'] as String),
          );
        }).toList();
        _model.updatePlans(plans);
      }

      // Prefetch any images after loading cached data
      if (_isMounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isMounted) {
            _prefetchImages();
          }
        });
      }
    } catch (e) {
      // If there's an error parsing cached data, we'll fetch fresh data
      if (_isMounted) {
        _model.setError('Error loading cached data');
      }
    }
  }

  // Save data to cache
  Future<void> _saveToCache(CoachRecord coach, List<PlansRecord> plans) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Prepare data for caching
      final coachData = {
        ...coach.snapshotData,
        'reference_path': coach.reference.path,
      };

      final plansData = plans
          .map((plan) => {
                ...plan.snapshotData,
                'reference_path': plan.reference.path,
              })
          .toList();

      final cacheData = {
        'timestamp': timestamp,
        'coach': coachData,
        'plans': plansData,
      };

      await prefs.setString(_cacheKey, jsonEncode(cacheData));
      _lastFetchTime = DateTime.now();
    } catch (e) {
      // Silently fail - caching is a performance optimization
    }
  }

  Future<void> _loadData() async {
    if (!_isMounted) return;
    if (currentUserReference == null) return;
    if (currentCoachDocument == null) return;

    try {
      final coach = currentCoachDocument!;
      if (_isMounted) {
        _model.updateCoach(coach);
      }

      final plansQuery = queryPlansRecord(
        queryBuilder: (plansRecord) => plansRecord.where(
          'plan.coach',
          isEqualTo: coach.reference,
        ),
      );

      final plans = await plansQuery.first;

      if (_isMounted) {
        _model.updatePlans(plans);
      }

      // Update the static cache
      CoachExercisesPlansCache.update(coach, plans);

      // Save fetched data to cache
      await _saveToCache(coach, plans);

      // Prefetch images after loading fresh data
      if (_isMounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isMounted) {
            _prefetchImages();
          }
        });
      }
    } catch (error) {
      if (_isMounted) {
        _model.setError(error.toString());
      }
    }
  }

  // Prefetch images for better performance
  Future<void> _prefetchImages() async {
    if (!_isMounted) return;

    // Early return if no plans are available
    if (_model.activePlans.isEmpty && _model.draftPlans.isEmpty) return;

    // Look for coach profile image if available
    if (_model.coach != null && currentUserPhoto.isNotEmpty && _isMounted) {
      precacheImage(CachedNetworkImageProvider(currentUserPhoto), context);
    }

    // Use local placeholder instead of external URL
    if (_isMounted) {
      precacheImage(const AssetImage('assets/images/error_image.png'), context);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    _isMounted = false;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CoachExercisesPlansModel>(
      create: (_) => _model,
      child: Consumer<CoachExercisesPlansModel>(
        builder: (context, model, _) {
          if (currentUserReference == null) {
            // Defer navigation until after build is complete
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushNamed('Login');
            });
            return const SizedBox.shrink();
          }

          if (model.isLoading) {
            return const LoadingIndicator();
          }

          if (model.errorMessage != null) {
            return PlansErrorWidget(
              error: model.errorMessage,
              onRetry: () {
                _model.refresh();
                _loadData();
              },
            );
          }

          if (model.coach == null) {
            return Container();
          }

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: _buildPlansContainer(model),
            ),
          );
        },
      ),
    );
  }

  // Memoize the fixed widgets like SizedBox for better performance
  Widget _divider(BuildContext context) => SizedBox(
        height: ResponsiveUtils.height(context, 24.0),
      );

  // Cache the decoration to avoid recreating it on every build
  BoxDecoration _containerDecoration = const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF4B39EF), Color(0xFF3700B3)],
      stops: [0.0, 1.0],
      begin: AlignmentDirectional(0.0, -1.0),
      end: AlignmentDirectional(0, 1.0),
    ),
  );

  Widget _buildPlansContainer(CoachExercisesPlansModel model) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      decoration: _containerDecoration,
      child: SafeArea(
        child: Padding(
          padding: ResponsiveUtils.padding(
            context,
            horizontal: 24.0,
            vertical: 0.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ResponsiveUtils.height(context, 24)),
              PlansHeader(
                coach: model.coach,
                adService: _adService,
              ),
              _divider(context),
              _buildTabBar(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _model.refresh();
                    await _loadData();
                    await _prefetchImages();
                    return Future<void>.delayed(
                        const Duration(milliseconds: 300));
                  },
                  child: _buildTabBarView(model),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: const Duration(milliseconds: 400))
        .slideY(begin: 0.25, duration: const Duration(milliseconds: 400));
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color:
            FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.2),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.width(context, 30),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: FlutterFlowTheme.of(context).info,
        unselectedLabelColor:
            FlutterFlowTheme.of(context).info.withOpacity(0.5),
        labelStyle: FlutterFlowTheme.of(context).titleMedium.copyWith(
              fontSize: ResponsiveUtils.fontSize(context, 16),
            ),
        indicator: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.width(context, 30),
          ),
        ),
        tabs: [
          Tab(
            text: FFLocalizations.of(context).getText('uc74cy6m'),
          ),
          Tab(
            text: FFLocalizations.of(context).getText('udv61i44'),
          ),
        ],
      ),
    ).animate().fade(duration: const Duration(milliseconds: 400));
  }

  Widget _buildTabBarView(CoachExercisesPlansModel model) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: ResponsiveUtils.height(context, 16.0),
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          // Active plans tab
          ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.width(context, 16),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: ResponsiveUtils.height(
                    context,
                    MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                child: PlansSection(
                  plans: model.activePlans,
                  title: FFLocalizations.of(context).getText('uc74cy6m'),
                  countLabel: FFLocalizations.of(context).getText('plans'),
                  loadData: _loadData,
                ),
              ),
            ),
          ),
          // Draft plans tab
          ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.width(context, 16),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: ResponsiveUtils.height(
                    context,
                    MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                child: PlansSection(
                  plans: model.draftPlans,
                  title: FFLocalizations.of(context).getText('udv61i44'),
                  countLabel: FFLocalizations.of(context).getText('drafts'),
                  isDraft: true,
                  loadData: _loadData,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: const Duration(milliseconds: 400));
  }
}
