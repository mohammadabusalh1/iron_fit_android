import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function(bool) onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: ResponsiveUtils.padding(context, horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Delete Icon with Animation
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).error.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: FlutterFlowTheme.of(context).error,
                      size: ResponsiveUtils.iconSize(context, 48),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: ResponsiveUtils.height(context, 24)),
            // Title
            Text(
              FFLocalizations.of(context).getText('confirmDelete'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 24),
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).error,
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 16)),
            // Warning Message
            Text(
              FFLocalizations.of(context)
                  .getText('areYouSureYouWantToDeleteThisNutritionPlan'),
              textAlign: TextAlign.center,
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 16),
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 8)),
            Text(
              FFLocalizations.of(context).getText('thisActionCannot'),
              textAlign: TextAlign.center,
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 14),
                color: FlutterFlowTheme.of(context).error,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 24)),
            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: () => onConfirm(false),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.height(context, 12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                      ),
                    ),
                    child: Text(
                      FFLocalizations.of(context).getText('cancel'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 16),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.width(context, 16)),
                // Delete Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onConfirm(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).error,
                      foregroundColor: FlutterFlowTheme.of(context).info,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.height(context, 12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      FFLocalizations.of(context).getText('delete'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 16),
                        color: FlutterFlowTheme.of(context).info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .scale(
          duration: 400.ms,
          curve: Curves.easeOutBack,
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
        )
        .fade(duration: 300.ms);
  }
}
