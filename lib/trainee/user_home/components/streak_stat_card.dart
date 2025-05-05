import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';

class StreakStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final TraineeRecord trainee;

  const StreakStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.trainee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
      margin: ResponsiveUtils.padding(context, vertical: 12, horizontal: 0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveUtils.height(context, 8)),
          _buildValue(context),
          if (trainee.achievements.isNotEmpty) _buildAchievements(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 16),
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        Icon(
          icon,
          color: FlutterFlowTheme.of(context).primary,
          size: ResponsiveUtils.iconSize(context, 24),
        ),
      ],
    );
  }

  Widget _buildValue(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 24),
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        Text(
          unit,
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: ResponsiveUtils.height(context, 16)),
        const Divider(),
        SizedBox(height: ResponsiveUtils.height(context, 8)),
        Text(
          FFLocalizations.of(context).getText('recentAchievements'),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 8)),
        Wrap(
          spacing: ResponsiveUtils.width(context, 8),
          runSpacing: ResponsiveUtils.height(context, 8),
          alignment: WrapAlignment.start,
          children: trainee.achievements
              .take(2)
              .map((achievement) => AchievementBadge(achievement: achievement))
              .toList(),
        ),
      ],
    );
  }
}

class AchievementBadge extends StatelessWidget {
  final Map<String, dynamic> achievement;

  const AchievementBadge({
    required this.achievement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.padding(context, horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                ResponsiveUtils.padding(context, horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color:
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: ResponsiveUtils.iconSize(context, 20),
            ),
          ),
          SizedBox(width: ResponsiveUtils.width(context, 8)),
          ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: ResponsiveUtils.width(context, 80)),
            child: Text(
              achievement['title'] ?? '',
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 12),
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
