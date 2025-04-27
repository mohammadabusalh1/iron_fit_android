import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
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
                size: 16,
                color: FlutterFlowTheme.of(context).primary,
              ),
              const SizedBox(width: 8),
              Text(
                FFLocalizations.of(context).getText('trainer_feedback'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedback,
            style: AppStyles.textCairo(
              context,
              fontSize: 12,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          if (adjustments != null && adjustments!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              FFLocalizations.of(context).getText('suggested_adjustments'),
              style: AppStyles.textCairo(
                context,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
            const SizedBox(height: 4),
            ...adjustments!.map(
              (adjustment) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.adjust,
                      size: 12,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        adjustment,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 12,
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
