import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'theme_cache.dart';
import 'empty_state.dart';
import '/utils/responsive_utils.dart';

class StatsTab extends StatelessWidget {
  final TraineeRecord traineeRecord;
  final ThemeCache themeCache;
  final ScrollController controller;

  const StatsTab({
    super.key,
    required this.traineeRecord,
    required this.themeCache,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Safely handle potential null values
    final history = List.from(traineeRecord.history)
      ..sort((a, b) => b['weight']
          .compareTo(a['weight'])); // Sort by weight in descending order
    final limitedHistory = history.take(5).toList();

    if (limitedHistory.isEmpty) {
      return EmptyState(
        icon: Icons.fitness_center_outlined,
        titleKey: 'no_exercise_stats',
        subtitleKey: 'start_working_out',
        themeCache: themeCache,
      );
    }

    return Padding(
      padding: ResponsiveUtils.padding(context, horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FFLocalizations.of(context).getText('lknc4121'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildCountBadge(context, limitedHistory.length.toString(),
                  Icons.fitness_center),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 20)),
          _buildExerciseStatsList(context, limitedHistory),
        ],
      ),
    );
  }

  Widget _buildExerciseStatsList(BuildContext context, List<dynamic> history) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final exercise = history[index];
        return _buildExerciseCard(context, exercise['key'], exercise);
      },
    );
  }

  Widget _buildExerciseCard(
      BuildContext context, String exerciseName, Map<String, dynamic> stats) {
    // Safely handle potential null values
    final weight = stats['weight']?.toString() ?? '0';

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.height(context, 16)),
      decoration: BoxDecoration(
        color: themeCache.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Show exercise details
          },
          borderRadius:
              BorderRadius.circular(ResponsiveUtils.width(context, 16)),
          child: Padding(
            padding:
                ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        exerciseName.replaceAll('qft_', '').toUpperCase(),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: ResponsiveUtils.padding(
                        context,
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: themeCache.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                            ResponsiveUtils.width(context, 12)),
                      ),
                      child: Text(
                        '$weight ${FFLocalizations.of(context).getText('maximum_weight')}',
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 12),
                          fontWeight: FontWeight.w500,
                          color: themeCache.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountBadge(BuildContext context, String count, IconData icon) {
    return Container(
      padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: themeCache.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.iconSize(context, 16),
            color: themeCache.primaryColor,
          ),
          SizedBox(width: ResponsiveUtils.width(context, 4)),
          Text(
            count,
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              fontWeight: FontWeight.w600,
              color: themeCache.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
