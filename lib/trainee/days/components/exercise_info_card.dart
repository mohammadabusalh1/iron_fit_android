import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

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
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
      ),
      child: Padding(
        padding: ResponsiveUtils.padding(context, horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: ResponsiveUtils.width(context, 60.0),
                    height: ResponsiveUtils.height(context, 60.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).accent1,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 30.0)),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: FlutterFlowTheme.of(context).primary,
                      size: ResponsiveUtils.iconSize(context, 30.0),
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
                            fontSize: ResponsiveUtils.fontSize(context, 16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.sports_gymnastics,
                              size: ResponsiveUtils.iconSize(context, 16),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            SizedBox(width: ResponsiveUtils.width(context, 4)),
                            Text(
                              '${daysItem.exercises.length.toString()} ${FFLocalizations.of(context).getText('exercises')}',
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 14),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ].divide(SizedBox(height: ResponsiveUtils.height(context, 4.0))),
                    ),
                  ),
                ].divide(SizedBox(width: ResponsiveUtils.width(context, 16.0))),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: ResponsiveUtils.iconSize(context, 20),
            ),
          ],
        ),
      ),
    );
  }
}
