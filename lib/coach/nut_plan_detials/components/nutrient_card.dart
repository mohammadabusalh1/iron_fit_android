import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NutrientCard extends StatelessWidget {
  final String localizationKey;
  final int? value;
  final IconData icon;

  const NutrientCard({
    super.key,
    required this.localizationKey,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        constraints: const BoxConstraints(
          maxHeight: 100,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: FlutterFlowTheme.of(context).black.withAlpha(15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: FlutterFlowTheme.of(context).primary),
            const SizedBox(height: 4),
            Text(
              valueOrDefault<String>(value?.toString(), '0'),
              style: AppStyles.textCairo(
                context,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              FFLocalizations.of(context).getText(localizationKey),
              style: AppStyles.textCairo(
                context,
                fontSize: 12,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
