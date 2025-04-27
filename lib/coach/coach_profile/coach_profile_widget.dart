import 'package:flutter/material.dart';
import 'package:iron_fit/coach/coach_settings/componants/sevices.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:logging/logging.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'components/components.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

// Initialize logger
final _logger = Logger('CoachProfileWidget');

// Cache for coach profile data
class CoachProfileCache {
  static CoachRecord? cachedCoachProfile;
  static DateTime? lastFetchTime;
  static const Duration cacheValidity = Duration(minutes: 5);

  static bool get isValid {
    if (cachedCoachProfile == null || lastFetchTime == null) return false;
    return DateTime.now().difference(lastFetchTime!) < cacheValidity;
  }

  static void update(CoachRecord coachRecord) {
    cachedCoachProfile = coachRecord;
    lastFetchTime = DateTime.now();
  }

  static void clear() {
    cachedCoachProfile = null;
    lastFetchTime = null;
  }
}

class CoachProfileWidget extends StatefulWidget {
  /// I want you to create coach profile with subscribe button
  const CoachProfileWidget({super.key});

  @override
  State<CoachProfileWidget> createState() => _CoachProfileWidgetState();
}

class _CoachProfileWidgetState extends State<CoachProfileWidget>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  CoachRecord? _coachRecord;
  bool _hasError = false;
  String _errorMessage = '';
  late AnimationController _animationController;

  // Scroll controller for parallax effect
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    _prefetchData();
    _animationController.forward();
  }

  // Prefetch data when widget initializes
  Future<void> _prefetchData() async {
    if (CoachProfileCache.isValid) {
      setState(() {
        _coachRecord = CoachProfileCache.cachedCoachProfile;
        _isLoading = false;
      });
      // Refresh in background
      _fetchCoachData(useCache: false);
    } else {
      await _fetchCoachData();
    }
  }

  Future<void> _fetchCoachData({bool useCache = true}) async {
    if (currentCoachDocument == null) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Coach data not found';
        _isLoading = false;
      });
      return;
    }

    try {
      final coachRecord = await queryCoachRecord(
        queryBuilder: (query) => query.where(
          'user',
          isEqualTo: currentUserReference,
        ),
        singleRecord: true,
      ).first;

      if (coachRecord.isEmpty) {
        setState(() {
          _hasError = true;
          _errorMessage = 'No coach profile found';
          _isLoading = false;
        });
        return;
      }

      CoachProfileCache.update(coachRecord.first);

      if (mounted && (!useCache || _coachRecord == null)) {
        setState(() {
          _coachRecord = coachRecord.first;
          _isLoading = false;
        });
      }
    } catch (e) {
      _logger.severe('Error fetching coach data: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load profile data';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    await _fetchCoachData(useCache: false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_hasError || _coachRecord == null) {
      return _buildErrorState();
    }

    return _buildProfileScreen(context, _coachRecord!);
  }

  Widget _buildErrorState() {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: FlutterFlowTheme.of(context).primary,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        strokeWidth: 3,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color:
                            FlutterFlowTheme.of(context).error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: FlutterFlowTheme.of(context).error,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _errorMessage.isNotEmpty
                          ? _errorMessage
                          : 'Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _refreshProfile,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).withCoachNavBar(3);
  }

  Widget _buildProfileScreen(
      BuildContext context, CoachRecord coachProfileCoachRecord) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).info.withOpacity(0.2),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                FlutterFlowTheme.of(context).primaryBackground,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _refreshProfile,
            color: FlutterFlowTheme.of(context).primary,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  setState(() {
                    _scrollOffset = _scrollController.offset;
                  });
                }
                return false;
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar with parallex effect
                  SliverAppBar(
                    expandedHeight: 220.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context)
                                  .primary
                                  .withOpacity(0.9),
                              FlutterFlowTheme.of(context)
                                  .tertiary
                                  .withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withOpacity(0.9),
                                FlutterFlowTheme.of(context)
                                    .tertiary
                                    .withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Animated background pattern
                              ...List.generate(10, (index) {
                                final random = math.Random(index);
                                return Positioned(
                                  left: random.nextDouble() *
                                      MediaQuery.of(context).size.width,
                                  top: random.nextDouble() * 220,
                                  child: Container(
                                    width: 50 + random.nextDouble() * 50,
                                    height: 50 + random.nextDouble() * 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF57370d)
                                          .withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ).animate(
                                  controller: _animationController,
                                  effects: [
                                    ScaleEffect(
                                      delay:
                                          Duration(milliseconds: index * 100),
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      curve: Curves.easeOutQuart,
                                    ),
                                    FadeEffect(
                                      delay:
                                          Duration(milliseconds: index * 100),
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      curve: Curves.easeOut,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      titlePadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      title: AnimatedOpacity(
                        opacity: _scrollOffset > 80 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 8, 16, 8),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF57370d),
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: currentUserPhoto != null &&
                                          currentUserPhoto.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: currentUserPhoto,
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: FlutterFlowTheme.of(context)
                                                .primary
                                                .withOpacity(0.2),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: FlutterFlowTheme.of(context)
                                                .primary
                                                .withOpacity(0.2),
                                            child: Icon(
                                              Icons.person,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 18,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: FlutterFlowTheme.of(context)
                                              .primary
                                              .withOpacity(0.2),
                                          child: Icon(
                                            Icons.person,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            size: 18,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  currentUserDisplayName,
                                  style: AppStyles.textCairo(
                                    context,
                                    color: FlutterFlowTheme.of(context).black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 8, 16, 0),
                        child: IconButton(
                          icon: Icon(
                            Icons.settings_rounded,
                            color: FlutterFlowTheme.of(context).black,
                            size: 24,
                          ),
                          onPressed: () {
                            context.pushNamed('CoachSettings');
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 8, 16, 0),
                        child: IconButton(
                          icon: Icon(
                            Icons.logout_rounded,
                            color: FlutterFlowTheme.of(context).black,
                            size: 24,
                          ),
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            logout(context);
                          },
                        )
                            .animate()
                            .fadeIn(duration: const Duration(milliseconds: 300))
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutQuint,
                            ),
                      ),
                    ],
                  ),

                  // Profile content
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -40),
                          child: ProfileHeader(
                            coachRecord: coachProfileCoachRecord,
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -20),
                          child: _buildDetailsSection(
                              context, coachProfileCoachRecord),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).withCoachNavBar(3),
    );
  }

  Widget _buildDetailsSection(
      BuildContext context, CoachRecord coachProfileCoachRecord) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 56.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SubscriptionCard(coach: coachProfileCoachRecord)
                .animate(controller: _animationController)
                .fadeIn(duration: const Duration(milliseconds: 600))
                .moveY(
                    begin: 20,
                    end: 0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutQuint),
            const SizedBox(height: 24),

            // Add about me section
            _buildAboutMeSection(context, coachProfileCoachRecord),
            const SizedBox(height: 24),

            // Add statistics section
            StatisticsRow(coach: coachProfileCoachRecord)
                .animate(controller: _animationController)
                .fadeIn(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600))
                .moveY(
                    begin: 20,
                    end: 0,
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutQuint),
            const SizedBox(height: 24),

            // Add social media links or activity feed here
            _buildSocialLinks(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    // List of social media platforms with their data
    final socialPlatforms = [
      {
        'icon': Icons.language_rounded,
        'label': 'Website',
        'color': const Color(0xFF3B82F6),
      },
      {
        'icon': Icons.facebook_rounded,
        'label': 'Facebook',
        'color': const Color(0xFF1877F2),
      },
      {
        'icon': Icons.alternate_email_rounded,
        'label': 'Email',
        'color': const Color(0xFFEA4335),
      },
      {
        'icon': Icons.phone_rounded,
        'label': 'Call',
        'color': const Color(0xFF34D399),
      },
      {
        'icon': Icons.inbox_rounded,
        'label': 'Message',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'icon': Icons.photo_camera_rounded,
        'label': 'Instagram',
        'color': const Color(0xFFE4405F),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            border: Border.all(
              color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: List.generate(
                  socialPlatforms.length,
                  (index) {
                    final platform = socialPlatforms[index];
                    return _buildSocialButton(
                      context,
                      icon: platform['icon'] as IconData,
                      label: platform['label'] as String,
                      color: platform['color'] as Color,
                      onTap: () {
                        // Handle social media action
                        HapticFeedback.lightImpact();
                      },
                      delay: Duration(milliseconds: 100 * index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      FFLocalizations.of(context).getText('shareMyProfile'),
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutQuint,
                  )
                  .fadeIn(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 400),
                  ),
            ],
          ),
        ),
      ],
    )
        .animate(controller: _animationController)
        .fadeIn(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 600))
        .moveY(
            begin: 20,
            end: 0,
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutQuint);
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required Duration delay,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: color.withOpacity(0.1),
      highlightColor: color.withOpacity(0.05),
      child: Container(
        width: 80,
        child: Column(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color:
                    FlutterFlowTheme.of(context).primaryText.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
          delay: delay,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuint,
        )
        .fade(
          begin: 0,
          end: 1,
          delay: delay,
          duration: const Duration(milliseconds: 400),
        );
  }

  Widget _buildAboutMeSection(BuildContext context, CoachRecord coachRecord) {
    // Track if the text is expanded
    final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);
    final bioText = coachRecord.aboutMe;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primaryBackground,
            FlutterFlowTheme.of(context).secondaryBackground,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).black.withOpacity(0.03),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              right: -25,
              top: -25,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -15,
              bottom: -15,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          Icons.person_outline_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        FFLocalizations.of(context).getText('i1jyd81k'),
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Quote icon at the start
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.format_quote,
                      color:
                          FlutterFlowTheme.of(context).primary.withOpacity(0.4),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ValueListenableBuilder<bool>(
                    valueListenable: isExpanded,
                    builder: (context, expanded, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedCrossFade(
                            firstChild: Text(
                              bioText,
                              style: TextStyle(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 15,
                                height: 1.6,
                                letterSpacing: 0.1,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            secondChild: Text(
                              bioText,
                              style: TextStyle(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 15,
                                height: 1.6,
                                letterSpacing: 0.1,
                              ),
                            ),
                            crossFadeState: expanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                          if (bioText.length > 100)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  isExpanded.value = !expanded;
                                  HapticFeedback.lightImpact();
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  minimumSize: const Size(10, 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      expanded ? 'Show less' : 'Read more',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    AnimatedRotation(
                                      turns: expanded ? 0.5 : 0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 16,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  // Quote icon at the end
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.format_quote,
                      color:
                          FlutterFlowTheme.of(context).primary.withOpacity(0.4),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(controller: _animationController)
        .fadeIn(
            delay: const Duration(milliseconds: 600),
            duration: const Duration(milliseconds: 600))
        .slideY(
            begin: 0.2,
            end: 0,
            delay: const Duration(milliseconds: 600),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutQuint);
  }
}
