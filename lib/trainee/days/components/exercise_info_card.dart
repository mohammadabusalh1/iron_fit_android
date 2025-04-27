import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ExerciseInfoCard extends StatelessWidget {
  final dynamic daysItem;

  const ExerciseInfoCard({
    super.key,
    required this.daysItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).accent1,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 30.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            daysItem.title,
                            'Workout Plan',
                          ),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.sports_gymnastics,
                              size: 16,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${daysItem.exercises.length.toString()} ${FFLocalizations.of(context).getText('exercises')}',
                              style: AppStyles.textCairo(
                                context,
                                fontSize: 14,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ].divide(const SizedBox(height: 4.0)),
                    ),
                  ),
                ].divide(const SizedBox(width: 16.0)),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
