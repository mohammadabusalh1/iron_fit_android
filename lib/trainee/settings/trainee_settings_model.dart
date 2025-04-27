import '/componants/user_nav/user_nav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'trainee_settings_widget.dart' show TraineeSettingsWidget;
import 'package:flutter/material.dart';

class TraineeSettingsModel extends FlutterFlowModel<TraineeSettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for userNav component.
  late UserNavModel userNavModel;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    userNavModel = createModel(context, () => UserNavModel());
  }

  @override
  void dispose() {
    userNavModel.dispose();
  }
}
