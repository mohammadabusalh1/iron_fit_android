import 'package:flutter/material.dart';
import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/componants/Styles.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({
    super.key,
  });

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.size.width * 0.05;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).info.withOpacity(0.2),
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CoachAppBar.coachAppBar(
        context,
        FFLocalizations.of(context).getText('features_nav' /* My Trainees */),
        null,
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            context.pushNamed('Contact');
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              FlutterFlowTheme.of(context).primary.withValues(alpha: 0.5),
              FlutterFlowTheme.of(context).primaryBackground,
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width < 600
                ? 2
                : width < 900
                    ? 3
                    : 4;
            final childAspectRatio = width < 600 ? 0.9 : 1.1;

            return Padding(
              padding:
                  EdgeInsets.fromLTRB(padding, padding * 2, padding, padding),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: padding,
                  mainAxisSpacing: padding,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final itemColor = FlutterFlowTheme.of(context).primary;
                  final items = [
                    {
                      'icon': Icons.people_alt_rounded,
                      'title': FFLocalizations.of(context).getText('zb6vtde1'),
                      'route': 'trainees',
                      'color': itemColor,
                    },
                    {
                      'icon': Icons.fitness_center,
                      'title': FFLocalizations.of(context).getText('7ndmh9dh'),
                      'route': 'CoachExercisesPlans',
                      'color': itemColor,
                    },
                    {
                      'icon': Icons.restaurant,
                      'title': FFLocalizations.of(context).getText('zs7ls2wz'),
                      'route': 'NutritionPlans',
                      'color': itemColor,
                    },
                    {
                      'icon': Icons.analytics_rounded,
                      'title': FFLocalizations.of(context).getText('al6z3vwj'),
                      'route': 'coachAnalytics',
                      'color': itemColor,
                    },
                  ];

                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final delay = index * 0.2;
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            delay,
                            delay + 0.4,
                            curve: Curves.easeOutQuart,
                          ),
                        ),
                      );

                      final fadeAnimation = Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            delay,
                            delay + 0.4,
                            curve: Curves.easeOut,
                          ),
                        ),
                      );

                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: SlideTransition(
                          position: slideAnimation,
                          child: _buildFeatureCard(
                            context: context,
                            icon: items[index]['icon'] as IconData,
                            title: items[index]['title'] as String,
                            color: items[index]['color'] as Color,
                            onTap: () {
                              context
                                  .pushNamed(items[index]['route'] as String);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    ).withCoachNavBar(1);
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width >= 600;
    final iconSize = isTablet ? 44.0 : 38.0;

    return Hero(
      tag: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: iconSize,
                ),
                SizedBox(height: isTablet ? 16 : 14),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: (isTablet
                        ? AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                        : AppStyles.textCairo(
                            context,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
