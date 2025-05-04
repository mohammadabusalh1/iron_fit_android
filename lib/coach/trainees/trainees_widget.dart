// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:iron_fit/Ad/AdService.dart';
import 'package:iron_fit/componants/CheckSubscribe/check_subscribe.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/coach/trainees/components/filter_tabs.dart';
import 'package:iron_fit/coach/trainees/components/search_bar.dart';
import 'package:iron_fit/coach/trainees/components/subscription_list.dart';
import 'package:iron_fit/coach/trainees/services/subscription_service.dart';
import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:lottie/lottie.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'trainees_model.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
export 'trainees_model.dart';

class CoachTraineesCache {
  static CoachRecord? cachedCoach;
  static DateTime? lastFetchTime;
  // Cache subscription lists
  static Map<String, List<SubscriptionsRecord>> cachedSubscriptions = {
    'active': [],
    'inactive': [],
    'requests': [],
    'deleted': [],
  };
  static const Duration cacheValidity = Duration(minutes: 5);

  static bool get isValid {
    if (cachedCoach == null || lastFetchTime == null) return false;
    return DateTime.now().difference(lastFetchTime!) < cacheValidity;
  }

  static void update(
      CoachRecord coach, Map<String, List<SubscriptionsRecord>> subscriptions) {
    cachedCoach = coach;
    cachedSubscriptions = subscriptions;
    lastFetchTime = DateTime.now();
  }

  static void clear() {
    cachedCoach = null;
    cachedSubscriptions = {
      'active': [],
      'inactive': [],
      'requests': [],
      'deleted': [],
    };
    lastFetchTime = null;
  }
}

class TraineesWidget extends StatefulWidget {
  const TraineesWidget({super.key});

  @override
  State<TraineesWidget> createState() => _TraineesWidgetState();
}

class _TraineesWidgetState extends State<TraineesWidget>
    with AutomaticKeepAliveClientMixin {
  late TraineesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AdService _adService;
  final TextEditingController _searchController = TextEditingController();

  // Move these into ValueNotifiers for more efficient state management
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _filterStatusNotifier =
      ValueNotifier<String>('active');

  Timer? _debounceTimer;
  BuildContext? _ancestorContext; // Store the ancestor context
  final GlobalKey sendAlertKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  // Track loading states for each subscription type
  final Map<String, ValueNotifier<bool>> _loadingStates = {
    'active': ValueNotifier<bool>(false),
    'inactive': ValueNotifier<bool>(false),
    'requests': ValueNotifier<bool>(false),
    'deleted': ValueNotifier<bool>(false),
  };

  // Add stream subscriptions to manage and dispose properly
  StreamSubscription? _coachSubscription;
  Map<String, StreamSubscription> _subscriptionStreams = {};

  // Track if initial data has been loaded
  bool _initialDataLoaded = false;

  @override
  bool get wantKeepAlive => true; // Keep this widget alive when navigating away

  @override
  void initState() {
    super.initState();
    Logger.info('Initializing TraineesWidget');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCoachData();
    });
    _model = createModel(context, () => TraineesModel());
    _adService = AdService();
    
    // Add delay to ad loading
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        _adService.loadAd(context);
      }
    });

    // Add listeners
    _searchController.addListener(_onSearchChanged);
    _filterStatusNotifier.addListener(_onFilterChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ancestorContext = context; // Save the context here
  }

  void _loadCoachData() {
    Logger.info('Loading coach data');

    if (CoachTraineesCache.isValid) {
      return;
    }

    if (currentCoachDocument == null) {
      Logger.info('User not authenticated');
      return;
    }

    _prefetchAllSubscriptionData(currentCoachDocument!.reference);
  }

  // New method to prefetch all subscription data at once
  void _prefetchAllSubscriptionData(DocumentReference coachRef) {
    Logger.info('Prefetching all subscription data for coach: ${coachRef.id}');
    // Cancel existing subscriptions
    _subscriptionStreams.forEach((_, subscription) => subscription.cancel());
    _subscriptionStreams.clear();

    // Set all loading states to true
    _loadingStates.forEach((key, notifier) {
      notifier.value = true;
    });

    // Track how many subscription types have loaded
    int loadedCount = 0;
    const int totalToLoad = 4; // active, inactive, requests, deleted

    void checkAllLoaded() {
      loadedCount++;
      if (loadedCount >= totalToLoad && !_initialDataLoaded) {
        _initialDataLoaded = true;
        Logger.info('All subscription data prefetched successfully');
      }
    }

    Map<String, List<SubscriptionsRecord>> subscriptions = {
      'active': [],
      'inactive': [],
      'requests': [],
      'deleted': [],
    };

    // Subscribe to active subscriptions
    _subscriptionStreams['active'] =
        SubscriptionService.getActiveSubscriptions(coachRef).listen((data) {
      setState(() {
        subscriptions['active'] = data;
        _loadingStates['active']!.value = false;
      });
      Logger.debug('Loaded ${data.length} active subscriptions');
      checkAllLoaded();
    }, onError: (error, stackTrace) {
      Logger.error('Error loading active subscriptions', error, stackTrace);
      _loadingStates['active']!.value = false;
      checkAllLoaded();
    });

    // Subscribe to inactive subscriptions
    _subscriptionStreams['inactive'] =
        SubscriptionService.getInactiveSubscriptions(coachRef).listen((data) {
      setState(() {
        subscriptions['inactive'] = data;
        _loadingStates['inactive']!.value = false;
      });
      Logger.debug('Loaded ${data.length} inactive subscriptions');
      checkAllLoaded();
    }, onError: (error, stackTrace) {
      Logger.error('Error loading inactive subscriptions', error, stackTrace);
      _loadingStates['inactive']!.value = false;
      checkAllLoaded();
    });

    // Subscribe to requests
    _subscriptionStreams['requests'] =
        SubscriptionService.getRequests(coachRef).listen((data) {
      setState(() {
        subscriptions['requests'] = data;
        _loadingStates['requests']!.value = false;
      });
      Logger.debug('Loaded ${data.length} subscription requests');
      checkAllLoaded();
    }, onError: (error, stackTrace) {
      Logger.error('Error loading subscription requests', error, stackTrace);
      _loadingStates['requests']!.value = false;
      checkAllLoaded();
    });

    // Subscribe to deleted subscriptions
    _subscriptionStreams['deleted'] =
        SubscriptionService.getDeletedSubscriptions(coachRef).listen((data) {
      setState(() {
        subscriptions['deleted'] = data;
        _loadingStates['deleted']!.value = false;
      });
      Logger.debug('Loaded ${data.length} deleted subscriptions');
      checkAllLoaded();
    }, onError: (error, stackTrace) {
      Logger.error('Error loading deleted subscriptions', error, stackTrace);
      _loadingStates['deleted']!.value = false;
      checkAllLoaded();
    });

    CoachTraineesCache.update(currentCoachDocument!, subscriptions);
  }

  @override
  void dispose() {
    Logger.info('Disposing TraineesWidget');
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    _model.dispose();
    _scrollController.dispose();

    // Clean up all streams
    _coachSubscription?.cancel();
    _subscriptionStreams.forEach((_, subscription) => subscription.cancel());

    // Clean up value notifiers
    _searchQueryNotifier.dispose();
    _filterStatusNotifier.dispose();

    // Clean up loading state notifiers
    _loadingStates.forEach((_, notifier) => notifier.dispose());

    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        _searchQueryNotifier.value = _searchController.text.toLowerCase();
      });
    });
  }

  void _onFilterChanged() {
    // This will rebuild only necessary widgets when filter changes
    setState(() {});
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQueryNotifier.value = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    // Get screen size
    final screenSize = MediaQuery.of(context).size;

    // If coach data is not loaded yet, show loading indicator
    if (CoachTraineesCache.cachedCoach == null) {
      return const LoadingIndicator();
    }

    return _buildScaffold(CoachTraineesCache.cachedCoach!, screenSize);
  }

  Widget _buildScaffold(CoachRecord coachRecord, Size screenSize) {
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final horizontalPadding = ResponsiveUtils.padding(
      context,
      horizontal: isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0),
      vertical: 0,
    ).horizontal / 2;

    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: CoachAppBar.coachAppBar(
          context,
          FFLocalizations.of(context).getText('kq4hr4fb'),
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            onPressed: () {
              context.pushNamed('coachFeatures');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: FlutterFlowTheme.of(context).primaryText,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            onPressed: () {
              context.pushNamed('Contact');
            },
          ),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.5),
                    FlutterFlowTheme.of(context).primaryBackground,
                  ],
                ),
              ),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Stack(
                children: [
                  _buildBodyContent(coachRecord, screenSize, orientation),
                  Positioned(
                    left: horizontalPadding,
                    bottom: ResponsiveUtils.height(context, 24),
                    child: _buildFloatingActionButton(coachRecord),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ).withCoachNavBar(1);
  }

  Widget _buildBodyContent(
      CoachRecord coachRecord, Size screenSize, Orientation orientation) {
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);
    
    final padding = ResponsiveUtils.padding(
      context,
      horizontal: isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0),
      vertical: isDesktop ? 24.0 : (isTablet ? 20.0 : 16.0),
    );
    
    final spacing = ResponsiveUtils.height(
      context, 
      isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0)
    );

    return RefreshIndicator(
      onRefresh: () async {
        _searchController.clear();
        _searchQueryNotifier.value = '';
        _filterStatusNotifier.value = 'active';
        _initialDataLoaded = false;
        CoachTraineesCache.clear();
        _prefetchAllSubscriptionData(coachRecord.reference);
      },
      color: FlutterFlowTheme.of(context).primary,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      strokeWidth: 3,
      displacement: 40,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(
          padding.horizontal / 2,
          padding.vertical / 2,
          padding.horizontal / 2,
          ResponsiveUtils.height(context, 24.0),
        ),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + ResponsiveUtils.height(context, 80)),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (orientation == Orientation.landscape && isTablet) {
                    // Landscape layout for tablet and desktop
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: SearchBarWidget(
                            controller: _searchController,
                            onSearch: _onSearchChanged,
                            onClear: _clearSearch,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          flex: 3,
                          child: ValueListenableBuilder<String>(
                            valueListenable: _filterStatusNotifier,
                            builder: (context, filterStatus, _) {
                              return FilterTabs(
                                currentFilter: filterStatus,
                                onFilterChanged: (value) {
                                  _filterStatusNotifier.value = value;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Portrait layout for all devices
                    return Column(
                      children: [
                        SearchBarWidget(
                          controller: _searchController,
                          onSearch: _onSearchChanged,
                          onClear: _clearSearch,
                        ),
                        SizedBox(height: spacing),
                        ValueListenableBuilder<String>(
                          valueListenable: _filterStatusNotifier,
                          builder: (context, filterStatus, _) {
                            return FilterTabs(
                              currentFilter: filterStatus,
                              onFilterChanged: (value) {
                                _filterStatusNotifier.value = value;
                              },
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: spacing + ResponsiveUtils.height(context, 16)),
              ValueListenableBuilder<String>(
                valueListenable: _filterStatusNotifier,
                builder: (context, filterStatus, _) {
                  return _buildSubscriptionLists(
                    coachRecord,
                    _searchQueryNotifier.value,
                    filterStatus,
                    screenSize,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionLists(
    CoachRecord coachRecord,
    String searchQuery,
    String filterStatus,
    Size screenSize,
  ) {
    final spacing = ResponsiveUtils.height(
      context, 
      ResponsiveUtils.isDesktop(context) 
          ? 32.0 
          : (ResponsiveUtils.isTablet(context) ? 24.0 : 16.0)
    );

    // Only include the needed section based on current filter status
    // This prevents unnecessary widget creation and comparison
    return ValueListenableBuilder<bool>(
        valueListenable: _loadingStates[filterStatus]!,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(spacing),
                child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            );
          }

          final Widget currentSection;

          switch (filterStatus) {
            case 'active':
              currentSection = _buildSubscriptionListSection(
                'active',
                titleKey: 'gs92ksz0',
                isActive: true,
                searchQuery: searchQuery,
                screenSize: screenSize,
              );
              break;
            case 'inactive':
              currentSection = _buildSubscriptionListSection(
                'inactive',
                titleKey: 'y39376zl',
                isActive: false,
                searchQuery: searchQuery,
                screenSize: screenSize,
                onSendAlert: () => _sendAlertToInactiveTrainees(
                  CoachTraineesCache.cachedSubscriptions['inactive']!
                      .where((sub) =>
                          sub.debts > 0 &&
                          (searchQuery.isEmpty ||
                              (sub.name.toLowerCase().contains(searchQuery))))
                      .toList(),
                  coachRecord.reference,
                ),
              );
              break;
            case 'requests':
              currentSection = _buildSubscriptionListSection(
                'requests',
                titleKey: 'requests',
                isRequests: true,
                searchQuery: searchQuery,
                screenSize: screenSize,
              );
              break;
            case 'deleted':
              currentSection = _buildSubscriptionListSection(
                'deleted',
                titleKey: 'deleted',
                searchQuery: searchQuery,
                screenSize: screenSize,
              );
              break;
            default:
              currentSection = const SizedBox.shrink();
          }

          return currentSection;
        });
  }

  // Optimized subscription list builder
  Widget _buildSubscriptionListSection(
    String cacheKey, {
    required String titleKey,
    bool isActive = false,
    bool isRequests = false,
    required String searchQuery,
    required Size screenSize,
    Function()? onSendAlert,
  }) {
    // Get cached data
    final subscriptions =
        CoachTraineesCache.cachedSubscriptions[cacheKey] ?? [];

    // Filter by search query
    final filteredSubscriptions = subscriptions.where((sub) {
      return searchQuery.isEmpty ||
          (sub.name.toLowerCase().contains(searchQuery));
    }).toList();

    // Return subscription list
    return SubscriptionList(
      subscriptions: filteredSubscriptions,
      titleKey: titleKey,
      isActive: isActive,
      isRequests: isRequests,
      onRestore: _restoreSubscription,
      onDelete: isRequests
          ? _showCancelSubscriptionDialog
          : _showPermanentDeleteDialog,
      onSendAlert: onSendAlert,
    );
  }

  Widget _buildFloatingActionButton(CoachRecord coachRecord) {
    return FloatingActionButton(
      
      backgroundColor: FlutterFlowTheme.of(context).primary,
      onPressed: () {
        _onAddClientPressed(coachRecord);
      },
      child: Icon(
        Icons.add,
        size: ResponsiveUtils.iconSize(context, 24),
      ),
    );
  }

  Future<void> _sendAlertToInactiveTrainees(
      List<SubscriptionsRecord> subscriptions, DocumentReference coach) async {
    int failureCount = 0;
    List<String> failedNames = [];

    for (final subscription in subscriptions) {
      if (subscription.trainee != null) {
        try {
          await SubscriptionService.createAlert(
            context: context,
            traineeRef: subscription.trainee!,
            name: FFLocalizations.of(context).getText('coachAlert'),
            desc: FFLocalizations.of(context).getText('itsTimeForPayment'),
            coach: coach,
          );
        } catch (e, stacktrace) {
          failureCount++;
          failedNames.add(subscription.name);
          Logger.error('Error setting alert for trainee ${subscription.name}',
              e, stacktrace);
        }
      }
    }

    if (mounted) {
      if (failureCount == 0) {
        showSuccessDialog(
            FFLocalizations.of(context).getText('alert_sent_success'), context);
      } else {
        String errorMessage =
            FFLocalizations.of(context).getText('alert_sent_partial_success');
        if (failedNames.isNotEmpty) {
          errorMessage +=
              '\n${FFLocalizations.of(context).getText('failed_for')}: ${failedNames.join(', ')}';
        }
        showErrorDialog(errorMessage, context);
      }
    }
  }

  void _restoreSubscription(SubscriptionsRecord subscription) async {
    bool? confirmRestore = await _showRestoreConfirmationDialog();
    if (confirmRestore == true) {
      try {
        await SubscriptionService.restoreSubscription(subscription);

        if (mounted) {
          showSuccessDialog(
              FFLocalizations.of(context).getText('restored_success'), context);
          // Refresh data after successful restore
          _initialDataLoaded = false;
          _prefetchAllSubscriptionData(currentCoachDocument!.reference);
        }
      } catch (e, stackTrace) {
        Logger.error('Error restoring subscription', e, stackTrace);
        if (mounted) {
          String errorMessage = FFLocalizations.of(context)
              .getText('error_restoring_subscription');
          if (e is FirebaseException) {
            switch (e.code) {
              case 'permission-denied':
                errorMessage =
                    FFLocalizations.of(context).getText('permission_denied');
                break;
              case 'not-found':
                errorMessage = FFLocalizations.of(context)
                    .getText('subscription_not_found');
                break;
              case 'network-request-failed':
                errorMessage =
                    FFLocalizations.of(context).getText('network_error');
                break;
              default:
                errorMessage =
                    '${FFLocalizations.of(context).getText('error_restoring_subscription')}: ${e.message}';
            }
          }
          showErrorDialog(errorMessage, context);
        }
      }
    }
  }

  Future<bool?> _showRestoreConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.restore,
                color: FlutterFlowTheme.of(context).primary,
                size: ResponsiveUtils.iconSize(context, 28),
              ),
              SizedBox(width: ResponsiveUtils.width(context, 12)),
              Text(
                FFLocalizations.of(context).getText('confirm_restore'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 20),
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
          content: Text(
            FFLocalizations.of(context).getText('are_you_sure_restore'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 16),
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                FFLocalizations.of(context).getText('cancel'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                FFLocalizations.of(context).getText('confirm'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showCancelSubscriptionDialog(
      SubscriptionsRecord subscription) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: FlutterFlowTheme.of(context).error,
                size: ResponsiveUtils.iconSize(context, 28),
              ),
              SizedBox(width: ResponsiveUtils.width(context, 12)),
              Text(
                FFLocalizations.of(context).getText('confirm'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 20),
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FFLocalizations.of(context).getText('areYouSure'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 8)),
              Text(
                FFLocalizations.of(context).getText('thisActionCannot'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  color: FlutterFlowTheme.of(context).error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                FFLocalizations.of(context).getText('cancel'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await subscription.reference.delete();
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                FFLocalizations.of(context).getText('confirm'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPermanentDeleteDialog(
      SubscriptionsRecord subscription) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: FlutterFlowTheme.of(context).error,
                size: ResponsiveUtils.iconSize(context, 28),
              ),
              SizedBox(width: ResponsiveUtils.width(context, 12)),
              Expanded(
                child: Text(
                  FFLocalizations.of(context).getText('permanent_delete'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 20),
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).error,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FFLocalizations.of(context).getText('permanent_delete_confirm'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 8)),
              Text(
                FFLocalizations.of(context).getText('permanent_delete_warning'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  color: FlutterFlowTheme.of(context).error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                FFLocalizations.of(context).getText('cancel'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await SubscriptionService.permanentlyDeleteSubscription(
                      subscription);
                  if (context.mounted) {
                    // Refresh data after successful restore
                    _initialDataLoaded = false;
                    _prefetchAllSubscriptionData(
                        currentCoachDocument!.reference);
                    Navigator.pop(context);
                    showSuccessDialog(
                        FFLocalizations.of(context)
                            .getText('permanent_delete_success'),
                        context);
                  }
                } catch (e, stackTrace) {
                  if (context.mounted) {
                    showErrorDialog(
                        FFLocalizations.of(context).getText('2184r6dy'),
                        context);
                  }
                  Logger.error(
                      'Error permanently deleting subscription', e, stackTrace);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                FFLocalizations.of(context).getText('delete'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _buildShowSuccessDialog(String message, BuildContext dialogContext) {
    showDialog(
      context: _ancestorContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                // Success animation
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Lottie.asset(
                          'assets/lottie/success.json',
                          fit: BoxFit.cover,
                          animate: true,
                          repeat: true,
                          width: ResponsiveUtils.width(context, 64),
                          height: ResponsiveUtils.height(context, 64),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
                // Success title
                Text(
                  FFLocalizations.of(context).getText('success'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 24),
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                // Success message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _searchController.clear();
                        _searchQueryNotifier.value = '';
                        _filterStatusNotifier.value = 'active';
                      });
                      Navigator.of(_ancestorContext!).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor: FlutterFlowTheme.of(context).info,
                      padding: ResponsiveUtils.padding(context, horizontal: 0, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      FFLocalizations.of(context).getText('ok'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: FlutterFlowTheme.of(context).info,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _onAddClientPressed(CoachRecord coachRecord) async {
    if (coachRecord.isSub == true) {
      context.pushNamed('AddClient').then((v) {
        if (v == 'none' || v == null) {
          return;
        } else if (v == 'Anonymous') {
          _buildShowSuccessDialog(
              FFLocalizations.of(context).getText('y22ou22a'), context);
          // Reload data after adding client
          _initialDataLoaded = false;
          _prefetchAllSubscriptionData(coachRecord.reference);
        } else {
          _buildShowSuccessDialog(
              FFLocalizations.of(context).getText('success_client_added'),
              context);
          // Reload data after adding client
          _initialDataLoaded = false;
          _prefetchAllSubscriptionData(coachRecord.reference);
        }
      });
    } else {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CheckSubscribe(
            showInterstitialAd: () {
              _adService.showInterstitialAd(context);
              _ancestorContext!.pushNamed('AddClient').then((v) {
                if (v == 'none' || v == null) {
                  return;
                } else if (v == 'Anonymous') {
                  _buildShowSuccessDialog(
                      FFLocalizations.of(_ancestorContext!).getText('y22ou22a'),
                      _ancestorContext!);
                  // Reload data after adding client
                  _initialDataLoaded = false;
                  _prefetchAllSubscriptionData(coachRecord.reference);
                } else {
                  _buildShowSuccessDialog(
                      FFLocalizations.of(_ancestorContext!)
                          .getText('success_client_added'),
                      _ancestorContext!);
                  // Reload data after adding client
                  _initialDataLoaded = false;
                  _prefetchAllSubscriptionData(coachRecord.reference);
                }
              });
            },
            page: '',
          );
        },
      );
    }
  }
}
