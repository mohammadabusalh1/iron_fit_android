import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LocalizationKeys {
  static const String today = 'today';
  static const String sets = 'sets';
  static const String reps = 'reps';
  static const String exercises = 'exercises';
  static const String loading = 'loading';
  static const String noNotifications = 'NoNotifications';
  static const String viewAll = 'view_all';
  static const String todayExercises = 'today_exercises';
  static const String inviteFriends = 'invite_friends';
}

class ExerciseCard extends StatelessWidget {
  final ExercisesRecord exercise;
  final int sets;
  final int reps;

  const ExerciseCard({
    required this.exercise,
    required this.sets,
    required this.reps,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.pushNamed(
                'exercise_details',
                queryParameters: {
                  'exerciseRef': exercise.reference.id,
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExerciseImage(context),
                _buildExerciseDetails(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseImage(BuildContext context) {
    final placeholder = Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          FlutterFlowTheme.of(context).primary,
        ),
      ),
    );

    final errorWidget = Icon(
      Icons.fitness_center,
      size: 40,
      color: FlutterFlowTheme.of(context).primary,
    );

    return Stack(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
          ),
          child: CachedNetworkImage(
            imageUrl: exercise.gifUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => placeholder,
            errorWidget: (_, __, ___) => errorWidget,
            memCacheWidth: 320,
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              FFLocalizations.of(context).getText(LocalizationKeys.today),
              style: AppStyles.textCairo(
                context,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).info,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseDetails(BuildContext context) {
    final exerciseTitle = exercise.name;
    final exerciseInfo =
        '$sets ${FFLocalizations.of(context).getText(LocalizationKeys.sets)} × $reps ${FFLocalizations.of(context).getText(LocalizationKeys.reps)}';

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exerciseTitle,
            style: AppStyles.textCairo(
              context,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.repeat,
                size: 14,
                color: FlutterFlowTheme.of(context).primary,
              ),
              const SizedBox(width: 4),
              Text(
                exerciseInfo,
                style: AppStyles.textCairo(
                  context,
                  fontSize: 12,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExerciseCardSkeleton extends StatelessWidget {
  const ExerciseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
