import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/utils/responsive_utils.dart';

class PlanHeaderSection extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final String? saveText;
  final Color? saveBackgroundColor;
  final Color? saveTextColor;

  const PlanHeaderSection({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    this.saveText,
    this.saveBackgroundColor,
    this.saveTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Create text styles once
    final titleStyle = AppStyles.textCairo(
      context,
      fontSize: ResponsiveUtils.fontSize(context, 16),
      fontWeight: FontWeight.bold,
    );

    final descriptionStyle = AppStyles.textCairo(
      context,
      fontSize: ResponsiveUtils.fontSize(context, 14),
      color: theme.secondaryText,
    );

    final saveStyle = saveText != null
        ? AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
            color: saveTextColor ?? const Color(0xFF1565C0),
          )
        : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (saveText != null)
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      ResponsiveUtils.width(context, 4),
                      0,
                      ResponsiveUtils.width(context, 4),
                      0,
                    ),
                    child: Text(
                      title,
                      style: titleStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      ResponsiveUtils.width(context, 4),
                      ResponsiveUtils.height(context, 8),
                      ResponsiveUtils.width(context, 4),
                      ResponsiveUtils.height(context, 8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: saveBackgroundColor ?? const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(ResponsiveUtils.width(context, 8)),
                        child: Text(
                          saveText!,
                          style: saveStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Text(
                title,
                style: titleStyle,
              ),
            Text(
              price,
              style: titleStyle,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            0,
            ResponsiveUtils.height(context, 8),
            0,
            0,
          ),
          child: Text(
            description,
            style: descriptionStyle,
          ),
        ),
      ],
    );
  }
}
