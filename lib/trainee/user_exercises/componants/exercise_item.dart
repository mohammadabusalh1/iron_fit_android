import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iron_fit/componants/timer/timer_widget.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'trainer_feedback_section.dart';

class ExerciseItem extends StatelessWidget {
  final ExerciseStruct exercise;
  final int index;
  final int day;
  final void Function(TraineeRecord)? onProgressUpdated;

  const ExerciseItem({
    super.key,
    required this.exercise,
    required this.index,
    required this.day,
    this.onProgressUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ExercisesRecord>(
      stream: ExercisesRecord.getDocument(exercise.ref!),
      key: ValueKey('exercise_stream_${exercise.ref?.id}'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingState(context);
        }
        final exerciseRecord = snapshot.data!;
        return _buildExerciseCard(context, exerciseRecord);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final secondaryBackground =
        FlutterFlowTheme.of(context).secondaryBackground;
    final primary = FlutterFlowTheme.of(context).primary;

    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: secondaryBackground.withAlpha(150),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: SizedBox(
          width: 40.0,
          height: 40.0,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: primary,
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
      BuildContext context, ExercisesRecord exerciseRecord) {
    // Cache theme values
    final theme = FlutterFlowTheme.of(context);
    final secondaryText = theme.secondaryText;
    final primaryBackground = theme.primaryBackground;
    final primaryText = theme.primaryText;
    final primary = theme.primary;
    final errorColor = theme.error;
    final info = theme.info;

    const double exerciseImageHeight = 230.0;

    return Container(
      decoration: BoxDecoration(
        color: primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: info.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: exerciseRecord.gifUrl,
                  width: double.infinity,
                  height: exerciseImageHeight,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Container(
                    color: primaryBackground,
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, _) => Container(
                    color: primaryBackground,
                    child: Icon(
                      Icons.error_outline,
                      color: errorColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primary.withAlpha(180),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${FFLocalizations.of(context).getText('exercise')} ${index + 1}',
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 12,
                      color: info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exerciseRecord.name,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 16,
                          color: secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          exercise.reps == 0 && exercise.time != 0
                              ? '${exercise.sets} ${FFLocalizations.of(context).getText('7eljwytw')} - ${exercise.time} ${exercise.timeType == 'm' ? FFLocalizations.of(context).getText('minutes') : FFLocalizations.of(context).getText('seconds')}'
                              : '${exercise.sets} ${FFLocalizations.of(context).getText('7eljwytw')} - ${exercise.reps} ${FFLocalizations.of(context).getText('wkyczine')}',
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 12,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TimerWidget(
                          key: Key('Keyqft_${exerciseRecord.name}'),
                          day: day,
                          sets: exercise.sets,
                          reps: exercise.reps,
                          time: exercise.time,
                          onProgressUpdated: onProgressUpdated,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          // Add Trainer Feedback Section if available
          if (exercise.trainerFeedback != null &&
              exercise.trainerFeedback.isNotEmpty)
            TrainerFeedbackSection(
              feedback: exercise.trainerFeedback,
              adjustments: exercise.trainerAdjustments,
            ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.2, duration: 400.ms);
  }
}
