import 'package:flutter/material.dart';
import 'package:iron_fit/coach/trainee/components/trainee_handlers.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class PaymentHistorySection extends StatelessWidget {
  final SubscriptionsRecord subscriptionsRecord;

  const PaymentHistorySection({
    super.key,
    required this.subscriptionsRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
      ),
      child: Container(
        width: ResponsiveUtils.width(context, MediaQuery.sizeOf(context).width),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
        ),
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    FFLocalizations.of(context).getText('25wwfzgl'),
                    style: AppStyles.textCairo(context,
                        fontSize: ResponsiveUtils.fontSize(context, 22), fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.payment_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                ],
              ),
              Divider(
                height: ResponsiveUtils.height(context, 24),
                thickness: ResponsiveUtils.width(context, 1),
                color: FlutterFlowTheme.of(context).alternate,
              ),
              Container(
                padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: ResponsiveUtils.width(context, 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context)
                              .getText('outstandingBalance'),
                          style: AppStyles.textCairo(context,
                              fontSize: ResponsiveUtils.fontSize(context, 14),
                              color:
                                  FlutterFlowTheme.of(context).secondaryText),
                        ),
                        Text(
                          '${subscriptionsRecord.debts} \$',
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'Inter Tight',
                                    fontSize: ResponsiveUtils.fontSize(context, 20),
                                    color: subscriptionsRecord.debts > 0
                                        ? FlutterFlowTheme.of(context).error
                                        : FlutterFlowTheme.of(context).success,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        TextButton(
                            onPressed: () {
                              showDebtsModal(subscriptionsRecord, context);
                            },
                            child: Text(
                              FFLocalizations.of(context)
                                  .getText('viewAllDebts'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 11),
                                color: FlutterFlowTheme.of(context).error,
                              ),
                            )),
                      ],
                    ),
                    Icon(
                      subscriptionsRecord.debts > 0
                          ? Icons.warning_rounded
                          : Icons.check_circle_rounded,
                      color: subscriptionsRecord.debts > 0
                          ? FlutterFlowTheme.of(context).error
                          : FlutterFlowTheme.of(context).success,
                      size: ResponsiveUtils.iconSize(context, 24),
                    ),
                  ],
                ),
              ),
              if (subscriptionsRecord.bills.isNotEmpty)
                Container(
                  padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: ResponsiveUtils.width(context, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText('zu4gu2ow'),
                            style: AppStyles.textCairo(context,
                                fontSize: ResponsiveUtils.fontSize(context, 14),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                          ),
                          Container(
                            padding: ResponsiveUtils.padding(
                                context, horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 8)),
                            ),
                            child: Text(
                              '${subscriptionsRecord.bills.last['paid']} \$',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: ResponsiveUtils.fontSize(context, 14),
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveUtils.height(context, 8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: ResponsiveUtils.iconSize(context, 16),
                              ),
                              SizedBox(width: ResponsiveUtils.width(context, 4)),
                              Text(
                                DateFormat('yyyy-MM-dd').format(
                                    subscriptionsRecord.bills.last['date']),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: ResponsiveUtils.fontSize(context, 14),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.check_circle_rounded,
                            color: FlutterFlowTheme.of(context).success,
                            size: ResponsiveUtils.iconSize(context, 20),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => TraineeHandlers.handleViewBills(
                            context, subscriptionsRecord),
                        child: Text(
                          FFLocalizations.of(context).getText('viewAllBills'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: ResponsiveUtils.fontSize(context, 11),
                            color: FlutterFlowTheme.of(context).success,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: ResponsiveUtils.width(context, 1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      FFLocalizations.of(context).getText('noPaymentsYet'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                ),
            ].divide(SizedBox(height: ResponsiveUtils.height(context, 16))),
          ),
        ),
      ),
    );
  }
}
