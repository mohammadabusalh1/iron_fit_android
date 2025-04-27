import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/componants/timer/timer_widget.dart';

import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class TimerModel extends FlutterFlowModel<TimerWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Timer widget.
  final timerInitialTimeMs = currentTraineeDocument!.preferredRestTime * 1000;
  int timerMilliseconds = currentTraineeDocument!.preferredRestTime * 1000;
  String timerValue = StopWatchTimer.getDisplayTime(
    90000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }
}
