import 'package:iron_fit/flutter_flow/form_field_controller.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'sign_up_widget.dart' show SignUpWidget;
import 'package:flutter/material.dart';

class SignUpModel extends FlutterFlowModel<SignUpWidget> {
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
  FormFieldController<List<String>>? userTypeController;
  double passwordStrength = 0.0;
  bool isChangingLanguage = false;
  bool isCaptchaVerified = false;

  // State field(s) for phone number widget
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberController;
  String? Function(BuildContext, String?)? phoneNumberControllerValidator;

  FocusNode? countryCodeFocusNode;
  TextEditingController? countryCodeController;
  String? Function(BuildContext, String?)? countryCodeControllerValidator;

  TextEditingController? fullNameController;
  FocusNode? fullNameFocusNode;

  TextEditingController? emailController;
  FocusNode? emailFocusNode;

  TextEditingController? phoneController;
  FocusNode? phoneFocusNode;

  TextEditingController? passwordController;
  FocusNode? passwordFocusNode;

  bool isLoading = false;
  bool isPasswordVisible = false;

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

    fullNameController?.dispose();
    fullNameFocusNode?.dispose();

    emailController?.dispose();
    emailFocusNode?.dispose();

    phoneController?.dispose();
    phoneFocusNode?.dispose();

    countryCodeController?.dispose();
    countryCodeFocusNode?.dispose();

    passwordController?.dispose();
    passwordFocusNode?.dispose();
  }
}
