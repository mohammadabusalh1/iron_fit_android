import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'create_exercise_plan_widget.dart' show CreateExercisePlanWidget;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CreateExercisePlanModel
    extends FlutterFlowModel<CreateExercisePlanWidget> {
  ///  Local state fields for this page.

  PlanStruct? draftPlan;
  void updateDraftPlanStruct(Function(PlanStruct) updateFn) {
    updateFn(draftPlan ??= PlanStruct());
  }

  ///  State fields for stateful widgets in this page.

  // State field(s) for PlanName widget.
  FocusNode? planNameFocusNode;
  TextEditingController? planNameTextController;
  String? Function(BuildContext, String?)? planNameTextControllerValidator;
  // State field(s) for desc widget.
  FocusNode? descFocusNode;
  TextEditingController? descTextController;
  String? Function(BuildContext, String?)? descTextControllerValidator;
  // State field(s) for Level widget.
  FormFieldController<List<String>>? levelValueController;
  String? get levelValue => levelValueController?.value?.firstOrNull;
  set levelValue(String? val) =>
      levelValueController?.value = val != null ? [val] : [];
  // State field(s) for goal widget.
  FormFieldController<List<String>>? goalValueController;
  String? get goalValue => goalValueController?.value?.firstOrNull;
  set goalValue(String? val) =>
      goalValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Bottom Sheet - selectDayForPlan] action in Button12 widget.
  TrainingDayStruct? dayData;
  // Stores action output result for [Firestore Query - Query a collection] action in Button1 widget.
  PlansRecord? planExist;

  @override
  void initState(BuildContext context) {
    levelValueController ??= FormFieldController<List<String>>([]);
    goalValueController ??= FormFieldController<List<String>>([]);
    draftPlan ??= PlanStruct();
  }

  @override
  void dispose() {
    planNameFocusNode?.dispose();
    planNameTextController?.dispose();

    descFocusNode?.dispose();
    descTextController?.dispose();
  }
}
