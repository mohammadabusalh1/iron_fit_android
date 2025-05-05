import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressCard extends StatelessWidget {
  final double progress;
  final double total;

  const ProgressCard({
    required this.progress,
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = progress > total ? 100 : ((progress / total) * 100);

    return Container(
      height: ResponsiveUtils.height(context,
          FFLocalizations.of(context).languageCode == 'ar' ? 160 : 180),
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: ResponsiveUtils.width(context, 80)),
                child: Text(
                  FFLocalizations.of(context).getText('rconapdq'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ),
              Icon(
                Icons.trending_up_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 12)),
          CircularPercentIndicator(
            percent: percentage / 100,
            radius: ResponsiveUtils.width(context, 35),
            lineWidth: ResponsiveUtils.width(context, 8),
            animation: true,
            animateFromLastPercent: true,
            progressColor: FlutterFlowTheme.of(context).primary,
            backgroundColor:
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
            center: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 16),
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
