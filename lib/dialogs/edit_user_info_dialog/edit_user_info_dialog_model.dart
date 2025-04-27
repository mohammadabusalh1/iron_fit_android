import '/flutter_flow/flutter_flow_util.dart';
import 'edit_user_info_dialog_widget.dart' show EditUserInfoDialogWidget;
import 'package:flutter/material.dart';

class EditUserInfoDialogModel
    extends FlutterFlowModel<EditUserInfoDialogWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // State field(s) for FullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;
  // State field(s) for weight widget.
  FocusNode? weightFocusNode;
  TextEditingController? weightTextController;
  String? Function(BuildContext, String?)? weightTextControllerValidator;
  // State field(s) for height widget.
  FocusNode? heightFocusNode;
  TextEditingController? heightTextController;
  String? Function(BuildContext, String?)? heightTextControllerValidator;
  // State field(s) for goal widget.
  FocusNode? goalFocusNode;
  TextEditingController? goalTextController;
  String? Function(BuildContext, String?)? goalTextControllerValidator;
  // State field(s) for date of birth widget.
  FocusNode? dateOfBirthFocusNode;
  TextEditingController? dateOfBirthTextController;
  String? Function(BuildContext, String?)? dateOfBirthTextControllerValidator;
  // State field(s) for gender
  String? gender;

  // Track if model actually changed to avoid unnecessary updates
  bool _modelChanged = false;

  @override
  void initState(BuildContext context) {
    dateOfBirthTextController = TextEditingController();
  }

  @override
  void onUpdate() {
    if (_modelChanged) {
      super.onUpdate();
      _modelChanged = false;
    }
  }

  // Override setter to track changes
  @override
  void updatePage(Function() updateFn) {
    _modelChanged = true;
    super.updatePage(updateFn);
  }

  @override
  void dispose() {
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

    weightFocusNode?.dispose();
    weightTextController?.dispose();

    heightFocusNode?.dispose();
    heightTextController?.dispose();

    goalFocusNode?.dispose();
    goalTextController?.dispose();

    dateOfBirthFocusNode?.dispose();
    dateOfBirthTextController?.dispose();
  }
}
