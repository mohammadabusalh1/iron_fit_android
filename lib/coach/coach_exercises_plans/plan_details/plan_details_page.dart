import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/backend.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

class PlanDetailsPage extends StatefulWidget {
  final PlansRecord plan;

  const PlanDetailsPage({
    super.key,
    required this.plan,
  });

  @override
  State<PlanDetailsPage> createState() => _PlanDetailsPageState();
}

class _PlanDetailsPageState extends State<PlanDetailsPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  // Map to track expanded state of each day
  final Map<int, bool> _expandedDays = {};
  // Map to store loaded exercise data
  final Map<String, ExercisesRecord> _exercisesCache = {};
  bool _isLoadingExercises = false;

  // Method to load all exercise data at once
  Future<void> _loadAllExercises() async {
    if (_isLoadingExercises) return;

    setState(() {
      _isLoadingExercises = true;
    });

    try {
      // Collect all unique exercise references
      final exerciseRefs = <DocumentReference>{};
      for (final day in widget.plan.plan.days) {
        for (final exercise in day.exercises) {
          if (exercise.hasRef() && exercise.ref != null) {
            exerciseRefs.add(exercise.ref!);
          }
        }
      }

      // Load all exercises in parallel
      final futures = exerciseRefs.map((ref) async {
        try {
          final data = await ExercisesRecord.getDocumentOnce(ref);
          return MapEntry(ref.id, data);
        } catch (e) {
          return null;
        }
      }).toList();

      final results = await Future.wait(futures);

      // Update the cache with the results
      for (final result in results) {
        if (result != null) {
          _exercisesCache[result.key] = result.value;
        }
      }
    } catch (e) {
      // Handle errors
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingExercises = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Load exercise data when the page is initialized
    _loadAllExercises();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          FFLocalizations.of(context).getText('itpi07oi'),
          style: AppStyles.textCairo(
            context,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: theme.primaryText,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildPlanContent(context, theme, size),
    );
  }

  Widget _buildPlanContent(
      BuildContext context, FlutterFlowTheme theme, Size size) {
    return Container(
      height: size.height,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 80),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4B39EF), Color(0xFF3700B3)],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(0.0, -1.0),
          end: AlignmentDirectional(0, 1.0),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgramHeader(context, theme),
            const SizedBox(height: 16),
            _buildDaysTimeline(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramHeader(BuildContext context, FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryBackground.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.plan.plan.name,
            style: AppStyles.textCairo(
              context,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.plan.plan.description,
            style: AppStyles.textCairo(
              context,
              fontSize: 14,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildProgramTag(theme, widget.plan.plan.type),
              const SizedBox(width: 8),
              _buildProgramTag(theme,
                  '${widget.plan.plan.days.length} ${FFLocalizations.of(context).getText('days')}'),
              const SizedBox(width: 8),
              _buildProgramTag(theme, widget.plan.plan.level),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgramTag(FlutterFlowTheme theme, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: theme.primary,
        ),
      ),
    );
  }

  Widget _buildDaysTimeline(BuildContext context, FlutterFlowTheme theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      itemCount: widget.plan.plan.days.length,
      itemBuilder: (context, index) {
        final day = widget.plan.plan.days[index];

        return _buildWorkoutDayCard(context, theme, day, day.day, index)
            .animate()
            .fade(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 100 * index),
              curve: Curves.easeOutQuad,
            )
            .slideY(
              begin: 0.2,
              duration: const Duration(milliseconds: 500),
              delay: Duration(milliseconds: 100 * index),
              curve: Curves.easeOutQuad,
            );
      },
    );
  }

  Widget _buildExerciseItemWithRef(BuildContext context, FlutterFlowTheme theme,
      ExerciseStruct exercise, int index) {
    if (exercise.hasRef() && exercise.ref != null) {
      final exerciseId = exercise.ref!.id;
      final exerciseData = _exercisesCache[exerciseId];

      if (exerciseData != null) {
        // Data is already loaded
        return _buildExerciseItemWithData(
          context,
          theme,
          exerciseData.name.isNotEmpty
              ? exerciseData.name
              : 'Exercise ${index + 1}',
          '${exercise.sets} × ${exercise.reps}',
          exerciseData.gifUrl,
        );
      } else if (_isLoadingExercises) {
        // Data is still loading
        return _buildLoadingExerciseItem(context, theme);
      } else {
        // Data failed to load or wasn't found - make a single request for this item
        return FutureBuilder<ExercisesRecord>(
          future: ExercisesRecord.getDocumentOnce(exercise.ref!).then((data) {
            // Store in cache for future reference
            if (data != null) {
              _exercisesCache[exerciseId] = data;
            }
            return data;
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingExerciseItem(context, theme);
            }

            if (snapshot.hasData && snapshot.data != null) {
              final exerciseData = snapshot.data!;
              return _buildExerciseItemWithData(
                context,
                theme,
                exerciseData.name.isNotEmpty
                    ? exerciseData.name
                    : 'Exercise ${index + 1}',
                '${exercise.sets} × ${exercise.reps}',
                exerciseData.gifUrl,
              );
            }

            // Fallback if data couldn't be loaded
            return _buildExerciseItem(
              context,
              theme,
              'Exercise ${index + 1}',
              '${exercise.sets} × ${exercise.reps}',
              Icons.fitness_center,
            );
          },
        );
      }
    } else {
      // No reference, just use the default item
      return _buildExerciseItem(
        context,
        theme,
        'Exercise ${index + 1}',
        '${exercise.sets} × ${exercise.reps}',
        Icons.fitness_center,
      );
    }
  }

  Widget _buildExerciseItem(BuildContext context, FlutterFlowTheme theme,
      String defaultName, String sets, IconData defaultIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.primaryBackground,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(defaultIcon, color: theme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              defaultName,
              style: AppStyles.textCairo(
                context,
                fontSize: 15,
                color: theme.primaryText,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                sets,
                style: AppStyles.textCairo(
                  context,
                  fontSize: 14,
                  color: theme.secondaryText,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  // No image to show
                },
                child: Icon(Icons.info_outline,
                    color: theme.secondaryText, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingExerciseItem(
      BuildContext context, FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.primaryBackground,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              FFLocalizations.of(context).getText('loading'),
              style: AppStyles.textCairo(
                context,
                fontSize: 15,
                color: theme.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItemWithData(BuildContext context,
      FlutterFlowTheme theme, String name, String sets, String imageUrl) {
    return GestureDetector(
      onTap: () {
        if (imageUrl.isNotEmpty) {
          _showExerciseImage(context, name, imageUrl);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.primaryBackground,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl.isEmpty
                  ? Icon(Icons.fitness_center, color: theme.primary, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: AppStyles.textCairo(
                  context,
                  fontSize: 15,
                  color: theme.primaryText,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  sets,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 14,
                    color: theme.secondaryText,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (imageUrl.isNotEmpty) {
                      _showExerciseImage(context, name, imageUrl);
                    }
                  },
                  child: Icon(Icons.info_outline,
                      color: theme.secondaryText, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDayCard(BuildContext context, FlutterFlowTheme theme,
      TrainingDayStruct day, String dayName, int index) {
    // Initialize expanded state if not already set
    _expandedDays[index] ??= true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.primaryBackground.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workout focus area
          if (day.hasTitle() && day.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      dayName,
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryText,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.fitness_center,
                          color: theme.primary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        day.title,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Conditionally show exercises and details based on expanded state
          if (_expandedDays[index] == true) ...[
            // Exercise list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (final exercise in day.exercises)
                    _buildExerciseItemWithRef(context, theme, exercise, index),
                ],
              ),
            ),

            // Workout details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FFLocalizations.of(context).getText('workout_details'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWorkoutStat(
                          context,
                          theme,
                          FFLocalizations.of(context).getText('exercises'),
                          '${day.exercises.length}'),
                      const SizedBox(width: 24),
                      _buildWorkoutStat(
                          context,
                          theme,
                          FFLocalizations.of(context).getText('7eljwytw'),
                          '${day.exercises.fold<int>(0, (sum, ex) => sum + ex.sets)}'),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Show less/more button
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _expandedDays[index] = !(_expandedDays[index] ?? true);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        _expandedDays[index] == true
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: theme.secondaryText),
                    Text(
                      _expandedDays[index] == true
                          ? FFLocalizations.of(context).getText('show_less')
                          : FFLocalizations.of(context).getText('show_more'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 14,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutStat(BuildContext context, FlutterFlowTheme theme,
      String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppStyles.textCairo(
            context,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.primaryText,
          ),
        ),
        Text(
          label,
          style: AppStyles.textCairo(
            context,
            fontSize: 14,
            color: theme.secondaryText,
          ),
        ),
      ],
    );
  }

  // Method to show the exercise image in full screen
  void _showExerciseImage(BuildContext context, String name, String imageUrl) {
    final theme = FlutterFlowTheme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top bar with exercise name and close button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // Exercise image
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: theme.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                FFLocalizations.of(context)
                                    .getText('image_load_error'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
