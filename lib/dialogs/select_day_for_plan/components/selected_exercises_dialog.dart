import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:iron_fit/backend/schema/exercises_record.dart';
import 'package:iron_fit/backend/schema/structs/index.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iron_fit/dialogs/select_sets/select_sets_widget.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class SelectedExercisesDialog extends StatefulWidget {
  final List<ExerciseStruct> selectedExercises;
  final Function(List<ExerciseStruct>) onExercisesChanged;

  const SelectedExercisesDialog({
    super.key,
    required this.selectedExercises,
    required this.onExercisesChanged,
  });

  @override
  State<SelectedExercisesDialog> createState() =>
      _SelectedExercisesDialogState();
}

class _SelectedExercisesDialogState extends State<SelectedExercisesDialog> {
  List<ExerciseStruct> selectedExercises = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedExercises = widget.selectedExercises;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.width(context, 16),
        ),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).secondaryBackground,
                  FlutterFlowTheme.of(context)
                      .secondaryBackground
                      .withValues(alpha: 0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: ResponsiveUtils.padding(context, vertical: 24, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with animated transition
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(ResponsiveUtils.width(context, 12)),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  FlutterFlowTheme.of(context)
                                      .primary
                                      .withValues(alpha: 0.7),
                                  FlutterFlowTheme.of(context).primary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: FlutterFlowTheme.of(context)
                                      .primary
                                      .withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.fitness_center_rounded,
                              color: Colors.white,
                              size: ResponsiveUtils.iconSize(context, 24),
                            ),
                          ),
                          SizedBox(width: ResponsiveUtils.width(context, 16)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FFLocalizations.of(context)
                                      .getText('selected_exercises'),
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: ResponsiveUtils.fontSize(context, 20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${selectedExercises.length} ${FFLocalizations.of(context).getText('exercises_selected')}',
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: ResponsiveUtils.fontSize(context, 14),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Close button with ripple effect
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(ResponsiveUtils.width(context, 8)),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .alternate
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: ResponsiveUtils.iconSize(context, 24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.height(context, 24)),

                    // Instructions with microinteraction
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 400),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 10 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: ResponsiveUtils.padding(
                          context, 
                          horizontal: 16, 
                          vertical: 12
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.05),
                              FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: ResponsiveUtils.iconSize(context, 20),
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            SizedBox(width: ResponsiveUtils.width(context, 12)),
                            Expanded(
                              child: Text(
                                FFLocalizations.of(context)
                                    .getText('tap_to_edit_exercise'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: ResponsiveUtils.fontSize(context, 14),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.height(context, 16)),

                    // List with staggered animation
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: selectedExercises.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: ResponsiveUtils.height(context, 12),
                        ),
                        itemBuilder: (context, index) {
                          final exercise = selectedExercises[index];
                          return _buildExerciseItem(context, exercise, index);
                        },
                      ),
                    ),

                    // Add confirm button
                    const SizedBox(height: 24),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: FFButtonWidget(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          widget.onExercisesChanged(selectedExercises);
                          Navigator.pop(context);
                        },
                        text: FFLocalizations.of(context).getText('confirm'),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 2,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildExerciseItem(
      BuildContext context, ExerciseStruct exercise, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: FutureBuilder<ExercisesRecord>(
        future: ExercisesRecord.getDocumentOnce(exercise.ref!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 80,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .alternate
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              ),
            );
          }

          final exerciseData = snapshot.data!;
          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
                final setsData = await _showEditSetsDialog(
                  context,
                  exercise.sets,
                  exercise.reps,
                  exercise.time,
                  exercise.timeType,
                );
                if (setsData != null) {
                  final updatedExercises =
                      List<ExerciseStruct>.from(selectedExercises);
                  updatedExercises[index] = exercise.copyWith(
                    sets: setsData.sets,
                    reps: setsData.reps,
                    time: setsData.time,
                    timeType: setsData.timeType,
                  );
                  setState(() {
                    selectedExercises = updatedExercises;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).secondaryBackground,
                      FlutterFlowTheme.of(context)
                          .secondaryBackground
                          .withValues(alpha: 0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Animated exercise image
                    Hero(
                      tag: 'exercise_edit_${exerciseData.reference.id}',
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: exerciseData.gifUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: FlutterFlowTheme.of(context)
                                  .alternate
                                  .withValues(alpha: 0.3),
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: FlutterFlowTheme.of(context)
                                  .alternate
                                  .withValues(alpha: 0.3),
                              child: Icon(
                                Icons.fitness_center,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Exercise details with improved layout
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            exerciseData.name,
                            style: AppStyles.textCairo(
                              context,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              // Sets badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      FlutterFlowTheme.of(context)
                                          .primary
                                          .withValues(alpha: 0.7),
                                      FlutterFlowTheme.of(context).primary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: FlutterFlowTheme.of(context)
                                          .primary
                                          .withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${exercise.sets} ${FFLocalizations.of(context).getText('7eljwytw')}',
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Reps or Time badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      exercise.time > 0
                                          ? Icons.timer_outlined
                                          : Icons.fitness_center_outlined,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      exercise.time > 0
                                          ? '${exercise.time} ${exercise.timeType == 'm' ? FFLocalizations.of(context).getText('minutes') : FFLocalizations.of(context).getText('seconds')}'
                                          : '${exercise.reps} ${FFLocalizations.of(context).getText('wkyczine')}',
                                      style: AppStyles.textCairo(
                                        context,
                                        fontSize: 12,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action buttons with visual feedback
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () async {
                              HapticFeedback.mediumImpact();
                              final setsData = await _showEditSetsDialog(
                                context,
                                exercise.sets,
                                exercise.reps,
                                exercise.time,
                                exercise.timeType,
                              );
                              if (setsData != null) {
                                final updatedExercises =
                                    List<ExerciseStruct>.from(
                                        selectedExercises);
                                updatedExercises[index] = exercise.copyWith(
                                  sets: setsData.sets,
                                  reps: setsData.reps,
                                  time: setsData.time,
                                  timeType: setsData.timeType,
                                );
                                setState(() {
                                  selectedExercises = updatedExercises;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Delete button
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              final updatedExercises =
                                  List<ExerciseStruct>.from(selectedExercises);
                              updatedExercises.removeAt(index);
                              setState(() {
                                selectedExercises = updatedExercises;
                              });
                              if (updatedExercises.isEmpty) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .error
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete_rounded,
                                color: FlutterFlowTheme.of(context).error,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<SetStruct?> _showEditSetsDialog(
    BuildContext context,
    int initialSets,
    int initialReps,
    int initialTime,
    String timeType,
  ) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: SelectSetsWidget(
              initialSets: initialSets,
              initialReps: initialReps,
              initialTime: initialTime,
              timeType: timeType,
            ),
          ),
        );
      },
    );
  }
}
