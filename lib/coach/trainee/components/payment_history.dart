import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A component that displays payment history including bills and debts.
class PaymentHistoryWidget extends StatelessWidget {
  final SubscriptionsRecord subscription;
  final VoidCallback onAddDebtsPressed;
  final VoidCallback onRemoveDebtsPressed;
  final VoidCallback onViewBillsPressed;
  final VoidCallback onViewDebtsPressed;

  const PaymentHistoryWidget({
    super.key,
    required this.subscription,
    required this.onAddDebtsPressed,
    required this.onRemoveDebtsPressed,
    required this.onViewBillsPressed,
    required this.onViewDebtsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        ),
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.payment_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                  SizedBox(width: ResponsiveUtils.width(context, 12)),
                  Text(
                    FFLocalizations.of(context)
                        .getText('25wwfzgl' /* Payment History */),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 18),
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLastPayment(context),
                  _buildDebts(context),
                ].divide(SizedBox(height: ResponsiveUtils.height(context, 12.0))),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAddDebtsButton(context),
                  _buildDebtRemovalButton(context),
                ].divide(SizedBox(width: ResponsiveUtils.width(context, 12.0))),
              ),
            ].divide(SizedBox(height: ResponsiveUtils.height(context, 16.0))),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms).moveY(
          begin: 50,
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildLastPayment(BuildContext context) {
    // Get the last bill if available
    final lastBill = subscription.bills.isNotEmpty
        ? (subscription.bills.toList()
              ..sort((a, b) => b['date'].compareTo(a['date'])))
            .first
        : null;

    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 8.0)),
      ),
      child: Padding(
        padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
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
                      .getText('zu4gu2ow' /* Last Payment */),
                  style: AppStyles.textCairo(context, fontSize: ResponsiveUtils.fontSize(context, 16)),
                ),
                if (lastBill != null) ...[
                  Text(
                    dateTimeFormat(
                      'relative',
                      lastBill['date'],
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 12),
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  TextButton(
                    onPressed: onViewBillsPressed,
                    child: Text(
                      FFLocalizations.of(context).getText('viewAllBills'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 11),
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  )
                ],
              ],
            ),
            if (lastBill != null)
              Text(
                '${lastBill['paid']} \$',
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  color: FlutterFlowTheme.of(context).primary,
                ),
              )
            else
              Text(
                FFLocalizations.of(context).getText('noPaymentsYet'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideX(
          begin: -0.1,
          end: 0.0,
          duration: 200.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildDebts(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 8.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
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
                          .getText('79u0ym2f' /* Debts */),
                      style: AppStyles.textCairo(context, fontSize: ResponsiveUtils.fontSize(context, 16)),
                    ),
                  ],
                ),
                Text(
                  '${subscription.debts} \$',
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    color: FlutterFlowTheme.of(context).error,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onViewDebtsPressed,
            child: Text(
              FFLocalizations.of(context).getText('viewAllDebts'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 11),
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddDebtsButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
        ),
        child: IconButton(
          onPressed: onAddDebtsPressed,
          icon: Icon(
            Icons.add_circle,
            size: ResponsiveUtils.iconSize(context, 24),
            color: FlutterFlowTheme.of(context).info,
          ),
        ),
      ),
    );
  }

  Widget _buildDebtRemovalButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).error,
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
        ),
        child: IconButton(
          onPressed: onRemoveDebtsPressed,
          icon: Icon(
            Icons.remove_circle,
            size: ResponsiveUtils.iconSize(context, 24),
            color: FlutterFlowTheme.of(context).info,
          ),
        ),
      ),
    );
  }
}
