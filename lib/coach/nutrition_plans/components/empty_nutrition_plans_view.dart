import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/componants/Styles.dart';

class EmptyNutritionPlansView extends StatelessWidget {
  final VoidCallback onTap;

  const EmptyNutritionPlansView({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 600.ms)
                .then(delay: 200.ms)
                .shake(duration: 1500.ms),
            const SizedBox(height: 16),
            Text(
              FFLocalizations.of(context).getText('noData'),
              style: AppStyles.textCairo(
                context,
                fontSize: 18,
                color: FlutterFlowTheme.of(context).secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(duration: 600.ms).moveY(
                begin: 10, end: 0, duration: 600.ms, curve: Curves.easeOut),
            const SizedBox(height: 8),
            Text(
              FFLocalizations.of(context).getText('tapPlusToAdd'),
              style: AppStyles.textCairo(
                context,
                fontSize: 14,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms).moveY(
                begin: 10, end: 0, duration: 600.ms, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}
