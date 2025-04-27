import 'package:flutter/material.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class SessionTimerDisplay extends StatelessWidget {
  final int durationMs;

  const SessionTimerDisplay({
    super.key,
    required this.durationMs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Format the duration nicely
    final displayTime = StopWatchTimer.getDisplayTime(
      durationMs,
      hours: true,
      milliSecond: false,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primary.withAlpha(30),
            theme.secondaryBackground,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: theme.secondaryText.withAlpha(30),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FFLocalizations.of(context).getText('session_duration'),
              style: AppStyles.textCairo(
                context,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: theme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  displayTime,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
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
