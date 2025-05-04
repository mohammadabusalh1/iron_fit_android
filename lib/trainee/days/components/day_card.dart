import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
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
      padding: EdgeInsetsDirectional.fromSTEB(0.0, ResponsiveUtils.height(context, 24.0), 0.0, 0.0),
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
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            decoration: BoxDecoration(
              color: isToday
                  ? FlutterFlowTheme.of(context).primary.withOpacity(0.3)
                  : FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
              border: isToday
                  ? Border.all(
                      color: FlutterFlowTheme.of(context).primary, 
                      width: ResponsiveUtils.width(context, 2))
                  : null,
            ),
            child: Padding(
              padding: ResponsiveUtils.padding(context, horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: FlutterFlowTheme.of(context).primary,
                        size: ResponsiveUtils.iconSize(context, 24.0),
                      ),
                      SizedBox(width: ResponsiveUtils.width(context, 8.0)),
                      Text(
                        daysItem.day,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 18),
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).info,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 16.0)),
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
