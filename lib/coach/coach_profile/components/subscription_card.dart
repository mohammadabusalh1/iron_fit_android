import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/componants/Styles.dart';

class SubscriptionCard extends StatelessWidget {
  final CoachRecord coach;

  const SubscriptionCard({
    super.key,
    required this.coach,
  });

  // Text styles helper
  TextStyle _getTextStyle(
    BuildContext context, {
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return AppStyles.textCairo(
      context,
      color: color ?? FlutterFlowTheme.of(context).primaryText,
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontStyle: fontStyle ?? FontStyle.normal,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (coach.isSub) {
      // Enhanced subscription active card
      return RepaintBoundary(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.05),
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
              ],
            ),
            border: Border.all(
              color:
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -15,
                bottom: -15,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.verified,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context)
                                    .getText('youAreSubscribed'),
                                style: _getTextStyle(
                                  context,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                FFLocalizations.of(context)
                                    .getText('subscription_active'),
                                style: _getTextStyle(
                                  context,
                                  fontSize: 14,
                                  color: FlutterFlowTheme.of(context)
                                      .info
                                      .withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 300))
                        .slideX(),
                    const SizedBox(height: 20),
                    RepaintBoundary(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: FlutterFlowTheme.of(context)
                                  .black
                                  .withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context)
                                          .getText('subscription_ends'),
                                      style: _getTextStyle(
                                        context,
                                        fontSize: 14,
                                        color: FlutterFlowTheme.of(context)
                                            .info
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    Text(
                                      dateTimeFormat(
                                          'MMM dd, yyyy', coach.subEndDate),
                                      style: _getTextStyle(
                                        context,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Days remaining indicator
                            _buildDaysRemainingIndicator(
                                context, coach.subEndDate),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 300))
                        .slideY(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().scale(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }

    // Non-subscriber case
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FlutterFlowTheme.of(context)
                .secondaryBackground
                .withValues(alpha: 0.1),
            FlutterFlowTheme.of(context)
                .secondaryBackground
                .withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.workspace_premium,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText('subscribe_now'),
                        style: _getTextStyle(
                          context,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        FFLocalizations.of(context)
                            .getText('subscription_reminder_description'),
                        style: _getTextStyle(
                          context,
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context)
                              .info
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FFButtonWidget(
              onPressed: () {
                context.pushNamed('Subscription');
              },
              text: FFLocalizations.of(context).getText('subscribe_button'),
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: FlutterFlowTheme.of(context).primaryBackground,
                size: 20,
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 48,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: _getTextStyle(
                  context,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                elevation: 0,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to show days remaining in subscription
  Widget _buildDaysRemainingIndicator(BuildContext context, DateTime? endDate) {
    if (endDate == null) return Container();

    final daysRemaining = endDate.difference(DateTime.now()).inDays;
    final color = daysRemaining < 7
        ? FlutterFlowTheme.of(context).error
        : FlutterFlowTheme.of(context).primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            daysRemaining < 7 ? Icons.timer : Icons.check_circle_outline,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            '$daysRemaining ${FFLocalizations.of(context).getText('days_left')}',
            style: _getTextStyle(
              context,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
