import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'trainee_widget.dart' show TraineeWidget;
import 'package:flutter/material.dart';

class TraineeModel extends FlutterFlowModel<TraineeWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Bottom Sheet - addDebts] action in Button widget.
  double? debt;
  // Stores action output result for [Bottom Sheet - addDebts] action in Button widget.
  double? debtDec;
  // State field(s) for TrainingPlan widget.
  String? trainingPlanValue;
  FormFieldController<String> trainingPlanValueController =
      FormFieldController<String>('none');
  // Stores action output result for [Firestore Query - Query a collection] action in TrainingPlan widget.
  PlansRecord? plan;
  // State field(s) for NutritionalPlan widget.
  String? nutritionalPlanValue;
  FormFieldController<String> nutritionalPlanValueController =
      FormFieldController<String>('none');
  // Stores action output result for [Firestore Query - Query a collection] action in NutritionalPlan widget.
  NutPlanRecord? nutPlan;

  String? debtTitle;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
