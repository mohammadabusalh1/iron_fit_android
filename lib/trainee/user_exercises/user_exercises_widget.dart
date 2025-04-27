import 'package:flutter/material.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_exercises_model.dart';

// Import the components
import 'componants/custom_app_bar.dart';
import 'componants/exercise_progress_card.dart';
import 'componants/exercises_list.dart';

export 'user_exercises_model.dart';

class UserExercisesWidget extends StatefulWidget {
  /// Widget that displays a list of exercises for a specific day
  ///
  /// [exercises] The list of exercises to display
  /// [maxProgress] The maximum progress value for the progress bar
  /// [day] The current day number
  const UserExercisesWidget({
    super.key,
    required this.exercises,
    required this.maxProgress,
    required this.day,
  });

  final List<ExerciseStruct>? exercises;
  final int maxProgress;
  final int day;

  @override
  State<UserExercisesWidget> createState() => _UserExercisesWidgetState();
}

class _UserExercisesWidgetState extends State<UserExercisesWidget> {
  late UserExercisesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TraineeRecord? _currentTraineeRecord;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserExercisesModel());
    _currentTraineeRecord = currentTraineeDocument;

    // Log page view event
    // _logPageViewEvent();

    // Start the session timer when the page loads
    _model.sessionTimer.onStartTimer();

    // Listen to the session timer ticks
    _model.sessionTimer.rawTime.listen((value) {
      _model.sessionDurationMs = value;

      if (_model.sessionDurationMs > (60 * 60 * 1000)) {
        _saveSessionDuration();
      }
    });
  }

  @override
  void dispose() {
    // Save session duration before disposing
    _saveSessionDuration();
    _model.dispose();
    super.dispose();
  }

  Future<void> _saveSessionDuration() async {
    try {
      if (_currentTraineeRecord != null && _model.sessionDurationMs > 0) {
        final userRef = _currentTraineeRecord!.reference;
        final currentDate = DateTime.now();

        // Convert milliseconds to seconds for storage
        final durationInSeconds = _model.sessionDurationMs ~/ 1000;

        List<SubscriptionsRecord> subscriptionRecords =
            await querySubscriptionsRecord(
          queryBuilder: (subscriptionsRecord) => subscriptionsRecord
              .where('trainee', isEqualTo: currentTraineeDocument!.reference)
              .where('isActive', isEqualTo: true)
              .where('isDeleted', isEqualTo: false),
          singleRecord: true,
        ).first;

        if (subscriptionRecords.isEmpty) {
          return;
        }

        final subscriptionRecord = subscriptionRecords.first;

        final events = await queryEventsRecord(
          queryBuilder: (eventsRecord) => eventsRecord
              .where('type', isEqualTo: 'session_duration')
              .where('trainee', isEqualTo: userRef)
              .where('coach', isEqualTo: subscriptionRecord.coach),
          singleRecord: true,
        ).first;

        if (events.isNotEmpty) {
          final event = events.first;

          if (event.timestamp.day == currentDate.day &&
              event.timestamp.month == currentDate.month &&
              event.timestamp.year == currentDate.year) {
            await event.reference.update({
              'timestamp': currentDate,
              'data': {
                'day': widget.day,
                'durationSeconds': FieldValue.increment(durationInSeconds),
              }
            });
          }
        } else {
          // Create an event record for this session
          await EventsRecord.collection.add(
            createEventsRecordData(
              type: 'session_duration',
              timestamp: currentDate,
              trainee: userRef,
              coach: subscriptionRecord.coach,
              data: {
                'day': widget.day,
                'durationSeconds': durationInSeconds,
              },
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving session duration: $e');
    }
  }

  // Log a page view event

  void _handleProgressUpdate(TraineeRecord updatedTrainee) {
    // Log exercise completion event
    // _logExerciseCompletionEvent();

    setState(() {
      _currentTraineeRecord = updatedTrainee;
    });
  }

  // Log exercise completion event

  @override
  Widget build(BuildContext context) {
    if (currentTraineeDocument == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('Login');
        }
      });
      return const LoadingIndicator();
    }
    return _buildMainContent(
        context, _currentTraineeRecord ?? currentTraineeDocument!);
  }

  Widget _buildMainContent(
      BuildContext context, TraineeRecord userExercisesTraineeRecord) {
    // Cache theme values
    final theme = FlutterFlowTheme.of(context);
    final secondaryBackground = theme.secondaryBackground;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: scaffoldKey,
          extendBodyBehindAppBar: true,
          appBar: const CustomAppBar(),
          body: Container(
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(color: secondaryBackground),
            child: SafeArea(
              top: true,
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExerciseProgressCard(
                        traineeRecord: userExercisesTraineeRecord,
                        day: widget.day,
                        maxProgress: widget.maxProgress,
                      ),
                      // Display current session duration
                      // SessionTimerDisplay(durationMs: _model.sessionDurationMs),
                      ExercisesList(
                        exercises: widget.exercises,
                        day: widget.day,
                        onProgressUpdated: _handleProgressUpdate,
                      ),
                      const SizedBox(height: 24.0),
                    ].divide(const SizedBox(height: 16.0)),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
