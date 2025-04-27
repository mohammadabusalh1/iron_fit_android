import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'user_enter_info_widget.dart' show UserEnterInfoWidget;
import 'package:flutter/material.dart';

class UserEnterInfoModel extends FlutterFlowModel<UserEnterInfoWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // State field(s) for FullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;
  // State field(s) for Age widget.
  FocusNode? dateOfBirthFocusNode;
  TextEditingController? dateOfBirthTextController;
  String? Function(BuildContext, String?)? dateOfBirthTextControllerValidator;
  // State field(s) for Gender widget.
  FormFieldController<List<String>>? genderValueController;
  String? get genderValue => genderValueController?.value?.firstOrNull;
  set genderValue(String? val) =>
      genderValueController?.value = val != null ? [val] : [];
  // State field(s) for hight widget.
  FocusNode? hightFocusNode;
  TextEditingController? hightTextController;
  String? Function(BuildContext, String?)? hightTextControllerValidator;
  // State field(s) for weight widget.
  FocusNode? weightFocusNode;
  TextEditingController? weightTextController;
  String? Function(BuildContext, String?)? weightTextControllerValidator;
  // State field(s) for goal widget.
  FormFieldController<List<String>>? goalValueController;
  String? get goalValue => goalValueController?.value?.firstOrNull;
  set goalValue(String? val) =>
      goalValueController?.value = val != null ? [val] : [];

  // State field(s) for training time - updated to a single time
  TimeOfDay? trainingTime;

  // State field(s) for rest time
  int preferredRestTime = 90; // Default to 1:30m (90 seconds)

  bool isSaving = false;

  @override
  void initState(BuildContext context) {
    goalValueController ??= FormFieldController<List<String>>([]);
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

    dateOfBirthFocusNode?.dispose();
    dateOfBirthTextController?.dispose();

    hightFocusNode?.dispose();
    hightTextController?.dispose();

    weightFocusNode?.dispose();
    weightTextController?.dispose();

    goalValueController?.dispose();
  }
}
