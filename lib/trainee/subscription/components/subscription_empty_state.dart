import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubscriptionEmptyState extends StatelessWidget {
  final VoidCallback loadData;
  const SubscriptionEmptyState({super.key, required this.loadData});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
            FlutterFlowTheme.of(context).primaryBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .primaryBackground
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.subscriptions_outlined,
                    size: 48,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    FFLocalizations.of(context).getText('noSubscriptionsFound'),
                    textAlign: TextAlign.center,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1,
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
                      fontSize: 14,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        FFLocalizations.of(context).getText('contactTrainer'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: loadData,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      FFLocalizations.of(context).getText('refresh'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 14,
                        color: FlutterFlowTheme.of(context).black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor:
                          FlutterFlowTheme.of(context).primaryBackground,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
