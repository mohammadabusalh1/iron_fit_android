import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class CurrentPlanSection extends StatelessWidget {
  final CoachRecord coachRecord;
  final SubscriptionsRecord subscriptionsRecord;

  const CurrentPlanSection({
    super.key,
    required this.coachRecord,
    required this.subscriptionsRecord,
  });

  Widget _buildDateInfo(
      BuildContext context, String label, String date, IconData icon) {
    return Container(
      padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: ResponsiveUtils.iconSize(context, 16),
              ),
              SizedBox(width: ResponsiveUtils.width(context, 4)),
              Text(
                label,
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 10),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 4)),
          Text(
            date,
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

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
                    FFLocalizations.of(context).getText('currentPlan'),
                    style: AppStyles.textCairo(context,
                        fontSize: ResponsiveUtils.fontSize(context, 22), fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .success
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 20)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        subscriptionsRecord.endDate!.isBefore(DateTime.now())
                            ? Icon(
                                Icons.close,
                                color: FlutterFlowTheme.of(context).error,
                                size: ResponsiveUtils.iconSize(context, 16),
                              )
                            : Icon(
                                Icons.check_circle,
                                color: FlutterFlowTheme.of(context).success,
                                size: ResponsiveUtils.iconSize(context, 16),
                              ),
                        SizedBox(width: ResponsiveUtils.width(context, 4)),
                        Text(
                          subscriptionsRecord.endDate!.isBefore(DateTime.now())
                              ? FFLocalizations.of(context).getText('y39376zl')
                              : FFLocalizations.of(context).getText('active'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: ResponsiveUtils.fontSize(context, 12),
                            fontWeight: FontWeight.w600,
                            color: subscriptionsRecord.endDate!
                                    .isBefore(DateTime.now())
                                ? FlutterFlowTheme.of(context).error
                                : FlutterFlowTheme.of(context).success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                height: ResponsiveUtils.height(context, 24),
                thickness: ResponsiveUtils.width(context, 1),
                color: FlutterFlowTheme.of(context).alternate,
              ),
              Container(
                padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: ResponsiveUtils.width(context, 1),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText('monthlyFee'),
                              style: AppStyles.textCairo(context,
                                  fontSize: ResponsiveUtils.fontSize(context, 12),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText),
                            ),
                            Text(
                              '${coachRecord.price} \$',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: ResponsiveUtils.fontSize(context, 20),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                        Container(
                          padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.attach_money_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: ResponsiveUtils.iconSize(context, 24),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.height(context, 16)),
                    Column(
                      children: [
                        _buildDateInfo(
                          context,
                          FFLocalizations.of(context).getText('1qacacys'),
                          DateFormat('yyyy-MM-dd')
                              .format(subscriptionsRecord.startDate!),
                          Icons.calendar_today_rounded,
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 16)),
                        _buildDateInfo(
                          context,
                          FFLocalizations.of(context).getText('nextPayment'),
                          DateFormat('yyyy-MM-dd')
                              .format(subscriptionsRecord.endDate!),
                          Icons.event_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ].divide(SizedBox(height: ResponsiveUtils.height(context, 16))),
          ),
        ),
      ),
    );
  }
}
