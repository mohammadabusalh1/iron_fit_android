import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/responsive_utils.dart';
import 'package:iron_fit/componants/Styles.dart';

class TrainerFeedbackSection extends StatelessWidget {
  final String feedback;
  final List<String>? adjustments;

  const TrainerFeedbackSection({
    super.key,
    required this.feedback,
    this.adjustments,
  });

  @override
  Widget build(BuildContext context) {
    if (feedback.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(ResponsiveUtils.width(context, 16)),
      padding: EdgeInsets.all(ResponsiveUtils.width(context, 12)),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withAlpha(15),
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withAlpha(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.comment,
                size: ResponsiveUtils.iconSize(context, 16),
                color: FlutterFlowTheme.of(context).primary,
              ),
              SizedBox(width: ResponsiveUtils.width(context, 8)),
              Text(
                FFLocalizations.of(context).getText('trainer_feedback'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 8)),
          Text(
            feedback,
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 12),
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          if (adjustments != null && adjustments!.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.height(context, 8)),
            Text(
              FFLocalizations.of(context).getText('suggested_adjustments'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 12),
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 4)),
            ...adjustments!.map(
              (adjustment) => Padding(
                padding: EdgeInsets.only(bottom: ResponsiveUtils.height(context, 4)),
                child: Row(
                  children: [
                    Icon(
                      Icons.adjust,
                      size: ResponsiveUtils.iconSize(context, 12),
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 4)),
                    Expanded(
                      child: Text(
                        adjustment,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 12),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
