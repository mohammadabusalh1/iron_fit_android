import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/coach/trainees/components/optimized_subscription_list.dart';

class SubscriptionList extends StatelessWidget {
  final List<SubscriptionsRecord> subscriptions;
  final String titleKey;
  final bool isActive;
  final bool isRequests;
  final Function(SubscriptionsRecord)? onRestore;
  final Function(SubscriptionsRecord)? onDelete;
  final Function()? onSendAlert;

  const SubscriptionList({
    super.key,
    required this.subscriptions,
    required this.titleKey,
    this.isActive = true,
    this.isRequests = false,
    this.onRestore,
    this.onDelete,
    this.onSendAlert,
  });

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return _buildEmptyContainer(context);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        OptimizedSubscriptionList(
          subscriptions: subscriptions,
          isRequests: isRequests,
          onRestore: onRestore,
          onDelete: onDelete,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final activeSubscriptions = isActive == false
        ? subscriptions.where((sub) => sub.debts > 0).toList()
        : subscriptions;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          FFLocalizations.of(context).getText(titleKey),
          style: AppStyles.textCairo(context,
              fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Row(
          children: [
            if (isActive == false &&
                onSendAlert != null &&
                activeSubscriptions.isNotEmpty)
              FFButtonWidget(
                onPressed: onSendAlert,
                text: FFLocalizations.of(context).getText(
                  '946kavdj' /* Send Alert */,
                ),
                options: FFButtonOptions(
                  height: 35.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter Tight',
                        color: FlutterFlowTheme.of(context).info,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                child: Text(
                  '${subscriptions.length} ${FFLocalizations.of(context).getText('traineeWord')}',
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
            ),
          ].divide(const SizedBox(width: 8.0)),
        ),
      ],
    );
  }

  Widget _buildEmptyContainer(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FFLocalizations.of(context).getText(titleKey),
                style: AppStyles.textCairo(
                  context,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      12.0, 8.0, 12.0, 8.0),
                  child: Text(
                    '0 ${FFLocalizations.of(context).getText('traineeWord')}',
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: _buildEmptyState(context),
        ),
      ].divide(const SizedBox(height: 24.0)),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated icon with pulse effect
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 1500),
            tween: Tween<double>(begin: 0.8, end: 1.1),
            builder: (context, double value, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_outline_rounded,
                      size: 48,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          // Animated text with fade and slide effect
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        FFLocalizations.of(context)
                            .getText('no_trainees_found'),
                        style: AppStyles.textCairo(
                          context,
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        FFLocalizations.of(context)
                            .getText('try_different_search'),
                        style: AppStyles.textCairo(
                          context,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
