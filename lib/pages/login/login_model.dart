import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  Local state fields for this page.

  int? nums;
  bool isChangingLanguage = false;
  bool isCaptchaVerified = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  CoachRecord? coach;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  TraineeRecord? trainee;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<AlertRecord>? alerts;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    emailTextController?.dispose();

    textFieldFocusNode2?.dispose();
    passwordTextController?.dispose();
  }
}
