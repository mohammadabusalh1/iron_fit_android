import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;

  const StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FFLocalizations.of(context).languageCode == 'ar' ? 150 : 170,
      padding: const EdgeInsets.all(16),
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
                constraints: const BoxConstraints(maxWidth: 80),
                child: Text(
                  title,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 16,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ),
              Icon(
                icon,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppStyles.textCairo(
              context,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          Text(
            unit,
            style: AppStyles.textCairo(
              context,
              fontSize: 14,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
