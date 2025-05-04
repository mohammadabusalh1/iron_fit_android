import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/utils/responsive_utils.dart';

class StatisticBox extends StatelessWidget {
  final IconData icon;
  final String? value;
  final String label;
  final bool showCurrency;
  final bool isError;
  final bool isLoading;

  const StatisticBox({
    super.key,
    required this.icon,
    this.value,
    required this.label,
    this.showCurrency = false,
    this.isError = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final boxWidth = (screenWidth - ResponsiveUtils.width(context, 64)) * 0.49;

    return Container(
      width: boxWidth,
      height: ResponsiveUtils.height(context, 120.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isError
                ? FlutterFlowTheme.of(context).error.withAlpha(180)
                : FlutterFlowTheme.of(context).primary.withAlpha(180),
            size: ResponsiveUtils.iconSize(context, 24),
          ),
          SizedBox(height: ResponsiveUtils.height(context, 8)),
          if (isLoading)
            SizedBox(
              width: ResponsiveUtils.width(context, 24),
              height: ResponsiveUtils.height(context, 24),
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              value ?? '0',
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 24),
                fontWeight: FontWeight.bold,
                color: isError
                    ? FlutterFlowTheme.of(context).error
                    : FlutterFlowTheme.of(context).primary,
              ),
            ),
          SizedBox(height: ResponsiveUtils.height(context, 4)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 12),
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
