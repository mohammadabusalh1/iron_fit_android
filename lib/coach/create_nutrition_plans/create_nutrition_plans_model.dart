import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_nutrition_plans_widget.dart' show CreateNutritionPlansWidget;
import 'package:flutter/material.dart';

class CreateNutritionPlansModel
    extends FlutterFlowModel<CreateNutritionPlansWidget> {
  ///  Local state fields for this page.

  NutPlanStruct? nutPlan;
  void updateNutPlanStruct(Function(NutPlanStruct) updateFn) {
    updateFn(nutPlan ??= NutPlanStruct());
  }

  ///  State fields for stateful widgets in this page.

  // State field(s) for name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  // State field(s) for numOfWeeks widget.
  FocusNode? numOfWeeksFocusNode;
  TextEditingController? numOfWeeksTextController;
  String? Function(BuildContext, String?)? numOfWeeksTextControllerValidator;
  // State field(s) for protein widget.
  FocusNode? proteinFocusNode;
  TextEditingController? proteinTextController;
  String? Function(BuildContext, String?)? proteinTextControllerValidator;
  // State field(s) for carbs widget.
  FocusNode? carbsFocusNode;
  TextEditingController? carbsTextController;
  String? Function(BuildContext, String?)? carbsTextControllerValidator;
  // State field(s) for fats widget.
  FocusNode? fatsFocusNode;
  TextEditingController? fatsTextController;
  String? Function(BuildContext, String?)? fatsTextControllerValidator;
  // Stores action output result for [Bottom Sheet - createMeal] action in IconButton widget.
  MealStruct? meal;
  // State field(s) for notes widget.
  FocusNode? notesFocusNode;
  TextEditingController? notesTextController;
  String? Function(BuildContext, String?)? notesTextControllerValidator;

  FocusNode? caloriesFocusNode;
  TextEditingController? caloriesTextController;
  String? Function(BuildContext, String?)? caloriesTextControllerValidator;

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  NutPlanRecord? nutPlanExist;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    numOfWeeksFocusNode?.dispose();
    numOfWeeksTextController?.dispose();

    proteinFocusNode?.dispose();
    proteinTextController?.dispose();

    carbsFocusNode?.dispose();
    carbsTextController?.dispose();

    fatsFocusNode?.dispose();
    fatsTextController?.dispose();

    notesFocusNode?.dispose();
    notesTextController?.dispose();

    caloriesFocusNode?.dispose();
    caloriesTextController?.dispose();
  }
}
