import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/responsive_utils.dart';
import 'exercise_item.dart';

class ExercisesList extends StatelessWidget {
  final List<ExerciseStruct>? exercises;
  final int day;
  final void Function(TraineeRecord)? onProgressUpdated;

  const ExercisesList({
    super.key,
    required this.exercises,
    required this.day,
    this.onProgressUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (exercises == null || exercises!.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exercises!.length,
          itemBuilder: (context, index) {
            final exercise = exercises![index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < exercises!.length - 1 ? ResponsiveUtils.height(context, 16.0) : 0,
              ),
              child: ExerciseItem(
                exercise: exercise,
                index: index,
                day: day,
                key: ValueKey('exercise_${exercise.ref?.id ?? index}'),
                onProgressUpdated: onProgressUpdated,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.width(context, 24.0)),
        child: Text(
          FFLocalizations.of(context).getText('noExercisesForToday'),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 16),
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
      ),
    );
  }
}
