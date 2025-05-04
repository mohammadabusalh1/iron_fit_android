import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveUtils.width(context, MediaQuery.sizeOf(context).width),
      height: ResponsiveUtils.height(context, 160),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).info,
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary.withOpacity(0.8),
            FlutterFlowTheme.of(context).tertiary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
            blurRadius: ResponsiveUtils.width(context, 10),
            offset: Offset(0, ResponsiveUtils.height(context, 3)),
          ),
        ],
      ),
      child: Padding(
        padding: ResponsiveUtils.padding(context, horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FFLocalizations.of(context).getText('subscriptionDetails'),
              style: AppStyles.textCairo(context,
                  fontSize: ResponsiveUtils.fontSize(context, 24), fontWeight: FontWeight.bold),
            ),
            Text(
              FFLocalizations.of(context).getText('manageYourFitnessJourney'),
              style: AppStyles.textCairo(context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).info.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
