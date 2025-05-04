import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'exercise_card.dart';

class ExercisesSection extends StatelessWidget {
  final TraineeRecord trainee;
  final Animation<double> animation;

  const ExercisesSection({
    required this.trainee,
    required this.animation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(100 * (1 - animation.value), 0),
          child: Opacity(
            opacity: animation.value,
            child: StreamBuilder<List<SubscriptionsRecord>>(
              stream: querySubscriptionsRecord(
                queryBuilder: (subscriptionsRecord) => subscriptionsRecord
                    .where('trainee', isEqualTo: trainee.reference)
                    .where('isActive', isEqualTo: true),
                singleRecord: true,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox();
                }

                return _buildExercisesList(context, snapshot.data!.first);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildExercisesList(
      BuildContext context, SubscriptionsRecord subscription) {
    if (subscription.plan == null) {
      return const SizedBox.shrink();
    }
    return StreamBuilder<PlansRecord>(
      stream: PlansRecord.getDocument(subscription.plan!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final plan = snapshot.data!;
        final exercises = _getTodayExercises(plan);

        if (exercises.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: ResponsiveUtils.padding(context, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExercisesHeader(context),
              SizedBox(height: ResponsiveUtils.height(context, 12)),
              SizedBox(
                height: ResponsiveUtils.height(context, 180),
                child: ListView.builder(
                  padding: ResponsiveUtils.padding(context, horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return FutureBuilder<ExercisesRecord>(
                      future: ExercisesRecord.getDocument(exercise.ref!).first,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const ExerciseCardSkeleton();
                        }
                        final exerciseData = snapshot.data!;
                        return ExerciseCard(
                          key: ValueKey(exerciseData.reference.id),
                          exercise: exerciseData,
                          sets: exercise.sets,
                          reps: exercise.reps,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<dynamic> _getTodayExercises(PlansRecord plan) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final dayMap = {
      1: ['Monday', 'الاثنين', 'الإثنين'],
      2: ['Tuesday', 'الثلاثاء'],
      3: ['Wednesday', 'الأربعاء', 'الاربعاء'],
      4: ['Thursday', 'الخميس'],
      5: ['Friday', 'الجمعة'],
      6: ['Saturday', 'السبت'],
      7: ['Sunday', 'الاحد', 'الأحد'],
    };

    final todayNames = dayMap[weekday] ?? [];
    final todayExercises = plan.plan.days
        .where((day) => todayNames.contains(day.title))
        .map((day) => day.exercises)
        .expand((exercises) => exercises)
        .toList();

    return todayExercises;
  }

  Widget _buildExercisesHeader(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.padding(context, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            FFLocalizations.of(context)
                .getText(LocalizationKeys.todayExercises),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          TextButton(
            onPressed: () => context.pushNamed('days'),
            child: Text(
              FFLocalizations.of(context).getText(LocalizationKeys.viewAll),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 14),
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
