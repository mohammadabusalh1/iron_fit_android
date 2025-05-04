import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GoalsStep extends StatelessWidget {
  final String? selectedGoal;
  final Function(String) onGoalSelected;

  const GoalsStep({
    super.key,
    required this.selectedGoal,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Cache localizations to reduce lookups
    final localizations = FFLocalizations.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      key: const ValueKey('goals_step'),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Header Section
            _buildAnimatedHeader(context, localizations),
            SizedBox(height: ResponsiveUtils.height(context, 24)),

            // Goals Grid with improved rebuild control
            _GoalsGrid(
              selectedGoal: selectedGoal,
              onGoalSelected: onGoalSelected,
              localizations: localizations,
            ),
            SizedBox(height: ResponsiveUtils.height(context, 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(
      BuildContext context, FFLocalizations localizations) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: ResponsiveUtils.padding(context, horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.15),
                    FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.flag_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: ResponsiveUtils.iconSize(context, 28),
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.width(context, 16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.getText(
                                  'set_your_goals' /* Set Your Goals */),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 24),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.height(context, 4)),
                            Text(
                              localizations.getText(
                                  'goal_subtitle' /* Choose a goal that matches your fitness journey */),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 14),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Separate stateless widget to implement shouldRebuild logic
class _GoalsGrid extends StatelessWidget {
  final String? selectedGoal;
  final Function(String) onGoalSelected;
  final FFLocalizations localizations;

  // Define goal data once to avoid recreating on each build
  static const _goalIconMap = {
    0: Icons.fitness_center,
    1: Icons.sports_gymnastics,
    2: Icons.accessibility_new,
    3: Icons.favorite,
  };

  const _GoalsGrid({
    required this.selectedGoal,
    required this.onGoalSelected,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    // Cache goal titles and descriptions
    final goalTitles = [
      localizations.getText('amdnrtzx'),
      localizations.getText('9d9lxfgp' /* Gain Muscle */),
      localizations.getText('duqb8whi' /* Build & Cut */),
      localizations.getText('build_muscle_lose_weight' /* Stay Fit */),
    ];

    // final goalDescriptions = [
    //   localizations.getText('build_strength'),
    //   localizations.getText('burn_fat'),
    //   localizations.getText('maintain_level' /* Lean muscle gain */),
    //   localizations.getText('boost_health' /* Maintain current shape */),
    // ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: ResponsiveUtils.height(context, 16),
        crossAxisSpacing: ResponsiveUtils.width(context, 16),
        childAspectRatio: 0.85,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _GoalCard(
          title: goalTitles[index],
          icon: _goalIconMap[index]!,
          index: index,
          isSelected: selectedGoal == goalTitles[index],
          onSelected: onGoalSelected,
        );
      },
    );
  }
}

// Extract goal card to its own widget with memoization
class _GoalCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;
  final bool isSelected;
  final Function(String) onSelected;

  const _GoalCard({
    required this.title,
    required this.icon,
    required this.index,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: () => onSelected(title),
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isSelected
                    ? FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.15)
                    : FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).alternate,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.2)
                                : FlutterFlowTheme.of(context)
                                    .alternate
                                    .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: isSelected
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryText,
                            size: ResponsiveUtils.iconSize(context, 32),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 16)),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppStyles.textCairo(
                            context,
                            fontSize: ResponsiveUtils.fontSize(context, 16),
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: ResponsiveUtils.height(context, 8),
                      right: ResponsiveUtils.width(context, 8),
                      child: Container(
                        padding: ResponsiveUtils.padding(context, horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: FlutterFlowTheme.of(context).info,
                          size: ResponsiveUtils.iconSize(context, 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  // ignore: invalid_override_of_non_virtual_member
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _GoalCard &&
        other.title == title &&
        other.icon == icon &&
        other.index == index &&
        other.isSelected == isSelected;
  }

  @override
  // ignore: invalid_override_of_non_virtual_member
  int get hashCode => Object.hash(title, icon, index, isSelected);
}
