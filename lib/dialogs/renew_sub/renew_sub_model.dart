import '/flutter_flow/flutter_flow_util.dart';
import 'renew_sub_widget.dart' show RenewSubWidget;
import 'package:flutter/material.dart';

class RenewSubModel extends FlutterFlowModel<RenewSubWidget> {
  TextEditingController? startDate;
  TextEditingController? endDate;

  FocusNode? startDateFocusNode;
  FocusNode? endDateFocusNode;

  // State field(s) for paid widget.
  FocusNode? paidFocusNode;
  TextEditingController? paidTextController;
  String? Function(BuildContext, String?)? paidTextControllerValidator;
  // State field(s) for debts widget.
  FocusNode? deptsFocusNode;
  TextEditingController? deptsTextController;
  String? Function(BuildContext, String?)? deptsTextControllerValidator;

  @override
  void initState(BuildContext context) {
    startDateFocusNode = FocusNode();
    endDateFocusNode = FocusNode();
    startDate = TextEditingController();
    endDate = TextEditingController();
  }

  @override
  void dispose() {
    paidFocusNode?.dispose();
    paidTextController?.dispose();

    deptsFocusNode?.dispose();
    deptsTextController?.dispose();
  }
}
