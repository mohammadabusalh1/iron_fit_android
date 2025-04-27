import '/componants/user_nav/user_nav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_profile_widget.dart' show UserProfileWidget;
import 'package:flutter/material.dart';

class UserProfileModel extends FlutterFlowModel<UserProfileWidget> {
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
