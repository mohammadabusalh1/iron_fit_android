import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'subscription_status.dart';

/// A component that handles subscription management UI and actions.
class SubscriptionManagementWidget extends StatelessWidget {
  final SubscriptionsRecord subscription;
  final VoidCallback onRenewPressed;
  final VoidCallback onCancelPressed;

  const SubscriptionManagementWidget({
    super.key,
    required this.subscription,
    required this.onRenewPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary.withAlpha(40),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    FFLocalizations.of(context)
                        .getText('jak72zqo' /* Subscription Management */),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SubscriptionInfoWidget(subscription: subscription),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRenewSubscriptionButton(context),
                  _buildCancelSubscriptionButton(context),
                ].divide(const SizedBox(width: 12.0)),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).moveY(
          begin: 50,
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildRenewSubscriptionButton(BuildContext context) {
    return Expanded(
      flex: 2,
      child: FFButtonWidget(
        onPressed: onRenewPressed,
        icon: Icon(
          Icons.refresh_rounded,
          size: 20,
          color: FlutterFlowTheme.of(context).info,
        ),
        text: FFLocalizations.of(context)
            .getText('0pnc4d43' /* Renew Subscription */),
        options: FFButtonOptions(
          width: 160.0,
          height: 50.0,
          padding: const EdgeInsets.all(0.0),
          color: FlutterFlowTheme.of(context).primary,
          textStyle: AppStyles.textCairo(
            context,
            fontSize: 14,
            color: FlutterFlowTheme.of(context).info,
          ),
          elevation: 0.0,
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buildCancelSubscriptionButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Tooltip(
          message: FFLocalizations.of(context)
              .getText('lr1wr1c3' /* Cancel Subscription */),
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).error,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onCancelPressed,
              icon: Icon(
                Icons.cancel_rounded,
                size: 28,
                color: FlutterFlowTheme.of(context).info,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
