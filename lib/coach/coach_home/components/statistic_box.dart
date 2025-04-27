import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';

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
    final boxWidth = (screenWidth - 64) * 0.52;

    return Container(
      width: boxWidth,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
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
            size: 24,
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              value ?? '0',
              style: AppStyles.textCairo(
                context,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isError
                    ? FlutterFlowTheme.of(context).error
                    : FlutterFlowTheme.of(context).primary,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.textCairo(
              context,
              fontSize: 12,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
