import '/flutter_flow/flutter_flow_util.dart';
import 'add_debts_widget.dart' show AddDebtsWidget;
import 'package:flutter/material.dart';

class AddDebtsModel extends FlutterFlowModel<AddDebtsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for debt widget.
  FocusNode? debtValueFocusNode;
  TextEditingController? debtValueController;
  TextEditingController? debtTitleController;
  FocusNode? debtTitleFocusNode;
  String? Function(BuildContext, String?)? debtValueControllerValidator;

  @override
  void initState(BuildContext context) {
    debtTitleController = TextEditingController();
    debtTitleFocusNode = FocusNode();
    debtValueFocusNode = FocusNode();
    debtValueController = TextEditingController();
  }

  @override
  void dispose() {
    debtValueFocusNode?.dispose();
    debtValueController?.dispose();
    debtTitleController?.dispose();
    debtTitleFocusNode?.dispose();
  }
}
