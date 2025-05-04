import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class NoDataPlaceholder extends StatelessWidget {
  const NoDataPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center_outlined,
            size: ResponsiveUtils.iconSize(context, 64),
            color: FlutterFlowTheme.of(context).secondaryText,
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                duration: 1500.ms,
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
              )
              .fadeIn(duration: 500.ms),
          SizedBox(height: ResponsiveUtils.height(context, 24)),
          Text(
            FFLocalizations.of(context).getText('noPlanAddedForYou'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 20),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ).animate().slideY(
                duration: 400.ms,
                begin: 0.5,
                curve: Curves.easeOut,
              ),
          SizedBox(height: ResponsiveUtils.height(context, 8)),
          Text(
            FFLocalizations.of(context).getText('noPlansDescription'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(
                delay: 200.ms,
                duration: 400.ms,
              ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
