import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'theme_cache.dart';
import 'empty_state.dart';
import '/utils/responsive_utils.dart';

class AchievementsTab extends StatelessWidget {
  final TraineeRecord traineeRecord;
  final ThemeCache themeCache;
  final ScrollController controller;

  const AchievementsTab({
    super.key,
    required this.traineeRecord,
    required this.themeCache,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Safely handle potential null values
    final achievements = traineeRecord.achievements;
    final totalAchievements = achievements.length;

    if (achievements.isEmpty) {
      return EmptyState(
        icon: Icons.emoji_events_outlined,
        titleKey: 'no_achievements',
        subtitleKey: 'start_earning',
        themeCache: themeCache,
      );
    }

    return Padding(
      padding: ResponsiveUtils.padding(context, horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FFLocalizations.of(context).getText('achievements'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildCountBadge(
                  context, totalAchievements.toString(), Icons.star_rounded),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 16)),
          _buildAchievementsGrid(context, achievements),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid(
      BuildContext context, List<dynamic> achievements) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ResponsiveUtils.width(context, 16),
        mainAxisSpacing: ResponsiveUtils.height(context, 16),
        childAspectRatio: 1.2,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        // Safely handle potential type issues
        final achievement = achievements[index] is Map<String, dynamic>
            ? achievements[index] as Map<String, dynamic>
            : <String, dynamic>{};
        return _buildAchievementCard(context, achievement, index);
      },
    );
  }

  Widget _buildAchievementCard(
      BuildContext context, Map<String, dynamic> achievement, int index) {
    // Instead of creating IconData dynamically, we'll use a default icon
    const iconData = Icons.emoji_events;
    final title = achievement['title'] as String? ?? 'Achievement';

    return Container(
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
            // Show achievement details
          },
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
          child: Padding(
            padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  size: ResponsiveUtils.iconSize(context, 32),
                  color: themeCache.primaryColor,
                ),
                SizedBox(height: ResponsiveUtils.height(context, 12)),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    fontWeight: FontWeight.w600,
                  ),
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
