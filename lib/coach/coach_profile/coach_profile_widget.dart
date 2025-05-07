import 'package:flutter/material.dart';
import 'package:iron_fit/coach/coach_settings/componants/sevices.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/utils/logger.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'components/components.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

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

  static Future<void> clear() async{
    Logger.info('Clearing coach profile cache');
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scrollController.addListener(() {
      setState(() {});
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
      Logger.error('Error fetching coach data: $e');
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
              height: ResponsiveUtils.height(
                  context, MediaQuery.of(context).size.height * 0.8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.all(ResponsiveUtils.width(context, 20)),
                      decoration: BoxDecoration(
                        color:
                            FlutterFlowTheme.of(context).error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: ResponsiveUtils.iconSize(context, 48),
                        color: FlutterFlowTheme.of(context).error,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.height(context, 24)),
                    Text(
                      _errorMessage.isNotEmpty
                          ? _errorMessage
                          : 'Something went wrong',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(context, 18),
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.height(context, 16)),
                    ElevatedButton.icon(
                      onPressed: _refreshProfile,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        foregroundColor: Colors.white,
                        padding: ResponsiveUtils.padding(
                          context,
                          horizontal: 24,
                          vertical: 12,
                        ),
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
                  setState(() {});
                }
                return false;
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar with parallex effect
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    actions: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0,
                            ResponsiveUtils.height(context, 8),
                            ResponsiveUtils.width(context, 16),
                            0),
                        child: IconButton(
                          icon: Icon(
                            Icons.settings_rounded,
                            color: FlutterFlowTheme.of(context).info,
                            size: ResponsiveUtils.iconSize(context, 24),
                          ),
                          onPressed: () {
                            context.pushNamed('CoachSettings');
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0,
                            ResponsiveUtils.height(context, 8),
                            ResponsiveUtils.width(context, 16),
                            0),
                        child: IconButton(
                          icon: Icon(
                            Icons.logout_rounded,
                            color: FlutterFlowTheme.of(context).info,
                            size: ResponsiveUtils.iconSize(context, 24),
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
                          offset:
                              Offset(0, -ResponsiveUtils.height(context, 40)),
                          child: ProfileHeader(
                            coachRecord: coachProfileCoachRecord,
                          ),
                        ),
                        Transform.translate(
                          offset:
                              Offset(0, -ResponsiveUtils.height(context, 20)),
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
        padding: EdgeInsetsDirectional.fromSTEB(
            ResponsiveUtils.width(context, 16.0),
            ResponsiveUtils.height(context, 12.0),
            ResponsiveUtils.width(context, 16.0),
            ResponsiveUtils.height(context, 88.0)),
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
            SizedBox(height: ResponsiveUtils.height(context, 24)),

            // Add about me section
            _buildAboutMeSection(context, coachProfileCoachRecord),
            SizedBox(height: ResponsiveUtils.height(context, 24)),

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
            SizedBox(height: ResponsiveUtils.height(context, 24)),

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
          padding: EdgeInsets.all(ResponsiveUtils.width(context, 24)),
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
                spacing: ResponsiveUtils.width(context, 16),
                runSpacing: ResponsiveUtils.height(context, 20),
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
              SizedBox(height: ResponsiveUtils.height(context, 20)),
              Container(
                padding: ResponsiveUtils.padding(
                  context,
                  horizontal: 20,
                  vertical: 12,
                ),
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
                      size: ResponsiveUtils.iconSize(context, 18),
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 8)),
                    Text(
                      FFLocalizations.of(context).getText('shareMyProfile'),
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveUtils.fontSize(context, 14),
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
        width: ResponsiveUtils.width(context, 80),
        child: Column(
          children: [
            Container(
              height: ResponsiveUtils.height(context, 54),
              width: ResponsiveUtils.width(context, 54),
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
                size: ResponsiveUtils.iconSize(context, 24),
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 10)),
            Text(
              label,
              style: TextStyle(
                color:
                    FlutterFlowTheme.of(context).primaryText.withOpacity(0.8),
                fontSize: ResponsiveUtils.fontSize(context, 12),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
              right: -ResponsiveUtils.width(context, 25),
              top: -ResponsiveUtils.height(context, 25),
              child: Container(
                width: ResponsiveUtils.width(context, 70),
                height: ResponsiveUtils.height(context, 70),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -ResponsiveUtils.width(context, 15),
              bottom: -ResponsiveUtils.height(context, 15),
              child: Container(
                width: ResponsiveUtils.width(context, 50),
                height: ResponsiveUtils.height(context, 50),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveUtils.width(context, 24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.all(ResponsiveUtils.width(context, 10)),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: ResponsiveUtils.iconSize(context, 22),
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.width(context, 12)),
                      Text(
                        FFLocalizations.of(context).getText('i1jyd81k'),
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: ResponsiveUtils.fontSize(context, 18),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 16)),
                  // Quote icon at the start
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.format_quote,
                      color:
                          FlutterFlowTheme.of(context).primary.withOpacity(0.4),
                      size: ResponsiveUtils.iconSize(context, 24),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 4)),
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
                                fontSize: ResponsiveUtils.fontSize(context, 15),
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
                                fontSize: ResponsiveUtils.fontSize(context, 15),
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
                                  padding: ResponsiveUtils.padding(
                                    context,
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size(
                                    ResponsiveUtils.width(context, 10),
                                    ResponsiveUtils.height(context, 10),
                                  ),
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
                                        fontSize: ResponsiveUtils.fontSize(
                                            context, 13),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            ResponsiveUtils.width(context, 4)),
                                    AnimatedRotation(
                                      turns: expanded ? 0.5 : 0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: ResponsiveUtils.iconSize(
                                            context, 16),
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
                      size: ResponsiveUtils.iconSize(context, 24),
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
