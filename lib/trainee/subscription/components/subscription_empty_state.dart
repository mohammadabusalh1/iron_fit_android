import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class SubscriptionEmptyState extends StatelessWidget {
  final VoidCallback loadData;
  const SubscriptionEmptyState({super.key, required this.loadData});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
            FlutterFlowTheme.of(context).primaryBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: ResponsiveUtils.width(context, 1),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: ResponsiveUtils.padding(context, vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .primaryBackground
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.subscriptions_outlined,
                    size: ResponsiveUtils.iconSize(context, 48),
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 8)),
                  Text(
                    FFLocalizations.of(context).getText('noSubscriptionsFound'),
                    textAlign: TextAlign.center,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 16)),
            Container(
              width: double.infinity,
              padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: ResponsiveUtils.width(context, 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    FFLocalizations.of(context).getText('checkBackLater'),
                    textAlign: TextAlign.center,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 12)),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: ResponsiveUtils.width(context, 8),
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: ResponsiveUtils.iconSize(context, 16),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        FFLocalizations.of(context).getText('contactTrainer'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 14),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 16)),
                  ElevatedButton.icon(
                    onPressed: loadData,
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: ResponsiveUtils.iconSize(context, 16),
                    ),
                    label: Text(
                      FFLocalizations.of(context).getText('refresh'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                        color: FlutterFlowTheme.of(context).black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor:
                          FlutterFlowTheme.of(context).primaryBackground,
                      padding: ResponsiveUtils.padding(
                          context, horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
