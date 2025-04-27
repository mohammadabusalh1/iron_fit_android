import '/flutter_flow/flutter_flow_util.dart';
import 'select_sets_widget.dart' show SelectSetsWidget;
import 'package:flutter/material.dart';

class SelectSetsModel extends FlutterFlowModel<SelectSetsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Sets widget.
  FocusNode? setsFocusNode;
  TextEditingController? setsTextController;
  String? Function(BuildContext, String?)? setsTextControllerValidator;
  // State field(s) for Reps widget.
  FocusNode? repsFocusNode;
  TextEditingController? repsTextController;
  String? Function(BuildContext, String?)? repsTextControllerValidator;
  // Add these lines
  TextEditingController? timeTextController;
  FocusNode? timeFocusNode;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    setsFocusNode?.dispose();
    setsTextController?.dispose();

    repsFocusNode?.dispose();
    repsTextController?.dispose();
    // Add these lines
    timeTextController?.dispose();
    timeFocusNode?.dispose();
  }
}
