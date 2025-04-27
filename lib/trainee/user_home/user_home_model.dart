import '/componants/user_nav/user_nav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_home_widget.dart' show UserHomeWidget;
import 'package:flutter/material.dart';

class UserHomeModel extends FlutterFlowModel<UserHomeWidget> {
  ///  Local state fields for this page.

  int? notiNum;

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
