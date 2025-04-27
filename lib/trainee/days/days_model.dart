import '/componants/user_nav/user_nav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'days_widget.dart' show DaysWidget;
import 'package:flutter/material.dart';

class DaysModel extends FlutterFlowModel<DaysWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for userNav component.
  late UserNavModel userNavModel;

  @override
  void initState(BuildContext context) {
    userNavModel = createModel(context, () => UserNavModel());
  }

  @override
  void dispose() {
    userNavModel.dispose();
  }
}
