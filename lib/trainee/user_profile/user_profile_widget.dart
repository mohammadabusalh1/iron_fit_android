import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'user_profile_model.dart';
import 'componants/theme_cache.dart';
import 'componants/background_gradient.dart';
import 'componants/profile_header.dart';
import 'componants/user_stats_section.dart';
import 'componants/profile_tabs.dart';
import 'componants/achievements_tab.dart';
import 'componants/stats_tab.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
export 'user_profile_model.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({super.key});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class UserCache {
  static TraineeRecord? userProfileTraineeRecord;
  static DateTime? lastUpdated;

  static bool isUpToDate() {
    if (userProfileTraineeRecord == null) {
      return false;
    }
    if (lastUpdated == null) {
      return false;
    }
    return DateTime.now().difference(lastUpdated!).inMinutes < 5;
  }

  static void updateTraineeRecord(TraineeRecord traineeRecord) {
    userProfileTraineeRecord = traineeRecord;
    lastUpdated = DateTime.now();
  }

  static void clearTraineeRecord() {
    userProfileTraineeRecord = null;
    lastUpdated = null;
  }
}

class _UserProfileWidgetState extends State<UserProfileWidget>
    with SingleTickerProviderStateMixin {
  late UserProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  // Cache for theme values to avoid repeated lookups
  late final ThemeCache _themeCache;
  bool _themeCacheInitialized = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserProfileModel());

    // Initialize tab controller
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_themeCacheInitialized) {
      _themeCache = ThemeCache(context);
      _themeCacheInitialized = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _model.dispose();
    super.dispose();
  }

  void refreshProfile() {
    // Clear the cache to force a refresh
    UserCache.clearTraineeRecord();
    // Trigger a rebuild
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Check authentication and redirect if needed
    if (currentUserReference == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushNamed('Login');
      });
      return const LoadingIndicator(); // Return empty widget while redirecting
    }

    if (UserCache.isUpToDate()) {
      return _buildUserProfile(context, UserCache.userProfileTraineeRecord!)
          .withUserNavBar(3);
    }

    final userProfileTraineeFuture = queryTraineeRecord(
      queryBuilder: (traineeRecord) => traineeRecord.where(
        'user',
        isEqualTo: currentUserReference,
      ),
      singleRecord: true,
    ).first;

    return FutureBuilder<List<TraineeRecord>>(
      future: userProfileTraineeFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const LoadingIndicator()
              .withUserNavBar(3); // Show loading with nav bar
        }
        UserCache.updateTraineeRecord(snapshot.data!.first);
        return _buildUserProfile(context, snapshot.data!.first)
            .withUserNavBar(3);
      },
    );
  }

  Widget _buildUserProfile(
      BuildContext context, TraineeRecord userProfileTraineeRecord) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _themeCache.primaryBackgroundColor,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Background gradient
            const BackgroundGradient(),

            // Main content
            SafeArea(
              child: SizedBox(
                height: ResponsiveUtils.screenHeight(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileHeader(
                        userProfileTraineeRecord: userProfileTraineeRecord,
                        themeCache: _themeCache,
                      ),

                      // User stats section
                      UserStatsSection(
                        userProfileTraineeRecord: userProfileTraineeRecord,
                        themeCache: _themeCache,
                        onProfileUpdated: refreshProfile,
                      ),

                      // Profile tabs
                      ProfileTabs(
                        tabController: _tabController,
                        themeCache: _themeCache,
                        onTabTap: (index) {
                          setState(() {});
                        },
                      ),

                      // TabBarView to show content based on selected tab
                      IndexedStack(
                        index: _tabController.index,
                        children: [
                          // Achievements Tab
                          AchievementsTab(
                            traineeRecord: userProfileTraineeRecord,
                            themeCache: _themeCache,
                            controller:
                                ScrollController(), // Dummy controller that won't be used for scrolling behavior
                          ),

                          // Stats Tab
                          StatsTab(
                            traineeRecord: userProfileTraineeRecord,
                            themeCache: _themeCache,
                            controller:
                                ScrollController(), // Dummy controller that won't be used for scrolling behavior
                          ),
                        ],
                      ),

                      // Add extra space at bottom for better scrolling experience
                      SizedBox(height: ResponsiveUtils.height(context, 20)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
