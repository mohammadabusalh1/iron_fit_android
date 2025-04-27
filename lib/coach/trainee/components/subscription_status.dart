import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';

/// A widget that displays subscription status information.
class SubscriptionStatusWidget extends StatelessWidget {
  final SubscriptionsRecord subscription;

  const SubscriptionStatusWidget({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FFLocalizations.of(context)
                      .getText('mwejm4ar' /* Subscription Status */),
                  style: AppStyles.textCairo(context, fontSize: 16),
                ),
                Text(
                  subscription.endDate! < getCurrentTimestamp
                      ? FFLocalizations.of(context)
                          .getText('y39376zl' /* Inactive */)
                      : FFLocalizations.of(context)
                          .getText('0gi3i7gz' /* Active */),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 14,
                    color: subscription.endDate! < getCurrentTimestamp
                        ? FlutterFlowTheme.of(context).error
                        : FlutterFlowTheme.of(context).success,
                  ),
                ),
                Text(
                  '${FFLocalizations.of(context).getText('expires')}: ${dateTimeFormat(
                    "relative",
                    subscription.endDate,
                    locale: FFLocalizations.of(context).languageCode,
                  )}',
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 12,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A more detailed subscription information widget with progress bar.
class SubscriptionInfoWidget extends StatelessWidget {
  final SubscriptionsRecord subscription;

  const SubscriptionInfoWidget({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    final bool isExpired = subscription.endDate! < getCurrentTimestamp;
    final daysRemaining =
        subscription.endDate!.difference(getCurrentTimestamp).inDays;

    // Add null/division by zero check
    double progressValue = 0.0;
    if (subscription.startDate != null && subscription.endDate != null) {
      final totalDays =
          subscription.endDate!.difference(subscription.startDate!).inDays;

      // Ensure we don't divide by zero and cap the progress at 1.0
      progressValue = totalDays > 0 && daysRemaining < totalDays
          ? ((totalDays - daysRemaining) / totalDays).clamp(0.0, 1.0)
          : 0.0;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpired
              ? FlutterFlowTheme.of(context).error.withAlpha(120)
              : FlutterFlowTheme.of(context).success.withAlpha(120),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FFLocalizations.of(context).getText('subscriptionStatus'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 14,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isExpired
                      ? FlutterFlowTheme.of(context).error.withAlpha(40)
                      : FlutterFlowTheme.of(context).success.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isExpired
                      ? FFLocalizations.of(context).getText('inactive')
                      : FFLocalizations.of(context).getText('active'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isExpired
                        ? FlutterFlowTheme.of(context).error
                        : FlutterFlowTheme.of(context).success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                context,
                icon: Icons.calendar_today_rounded,
                label: FFLocalizations.of(context).getText('startDate'),
                value: dateTimeFormat(
                  'MMM d, y',
                  subscription.startDate,
                  locale: FFLocalizations.of(context).languageCode,
                ),
              ),
              _buildInfoItem(
                context,
                icon: Icons.event_rounded,
                label: FFLocalizations.of(context).getText('endDate'),
                value: dateTimeFormat(
                  'MMM d, y',
                  subscription.endDate,
                  locale: FFLocalizations.of(context).languageCode,
                ),
                valueColor: isExpired
                    ? FlutterFlowTheme.of(context).error
                    : FlutterFlowTheme.of(context).success,
              ),
            ],
          ),
          if (!isExpired) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: FlutterFlowTheme.of(context).accent4,
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$daysRemaining ${FFLocalizations.of(context).getText('daysRemaining')}',
              style: AppStyles.textCairo(
                context,
                fontSize: 12,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppStyles.textCairo(
                context,
                fontSize: 12,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppStyles.textCairo(
            context,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? FlutterFlowTheme.of(context).primaryText,
          ),
        ),
      ],
    );
  }
}
