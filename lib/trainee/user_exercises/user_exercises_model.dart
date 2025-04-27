import 'package:iron_fit/componants/timer/timer_model.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'user_exercises_widget.dart' show UserExercisesWidget;
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class UserExercisesModel extends FlutterFlowModel<UserExercisesWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Slider widget.
  double? sliderValue;
  // Models for timer dynamic component.
  late FlutterFlowDynamicModels<TimerModel> timerModels;

  // Session timer for tracking workout duration
  final StopWatchTimer sessionTimer =
      StopWatchTimer(mode: StopWatchMode.countUp);
  int sessionDurationMs = 0;

  @override
  void initState(BuildContext context) {
    timerModels = FlutterFlowDynamicModels(() => TimerModel());
  }

  @override
  void dispose() {
    timerModels.dispose();
    sessionTimer.dispose();
  }
}
