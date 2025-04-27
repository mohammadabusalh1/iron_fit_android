import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import 'exercise_info_card.dart';

class DayCard extends StatelessWidget {
  final dynamic daysItem;
  final bool isToday;
  final VoidCallback onTap;

  const DayCard({
    super.key,
    required this.daysItem,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            decoration: BoxDecoration(
              color: isToday
                  ? FlutterFlowTheme.of(context).primary.withOpacity(0.3)
                  : FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(16.0),
              border: isToday
                  ? Border.all(
                      color: FlutterFlowTheme.of(context).primary, width: 2)
                  : null,
            ),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        daysItem.day,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ExerciseInfoCard(daysItem: daysItem),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, duration: 300.ms);
  }
}
