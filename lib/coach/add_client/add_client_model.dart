import '/backend/backend.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class AddClientModel extends ChangeNotifier {
  ///  State fields for stateful widgets in this page.

  // Text controllers
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController goalTextController = TextEditingController();
  final TextEditingController paidTextController = TextEditingController();
  final TextEditingController debtsTextController = TextEditingController();
  final TextEditingController startDateTextController = TextEditingController();
  final TextEditingController endDateTextController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Focus nodes
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode goalFocusNode = FocusNode();
  final FocusNode paidFocusNode = FocusNode();
  final FocusNode debtsFocusNode = FocusNode();
  final FocusNode startDateFocusNode = FocusNode();
  final FocusNode endDateFocusNode = FocusNode();
  final FocusNode notesFocusNode = FocusNode();

  // Form controllers
  final FormFieldController<String> levelValueController =
      FormFieldController('');
  final FormFieldController<String> trainingPlanController =
      FormFieldController(null);
  final FormFieldController<String> nutritionalPlanController =
      FormFieldController(null);

  // Validation error states
  String? emailError;
  String? nameError;
  String? paidError;
  String? debtsError;
  String? startDateError;
  String? endDateError;
  String? goalError;
  String? levelError;

  // Selected plan references
  PlansRecord? selectedTrainingPlan;
  NutPlanRecord? selectedNutritionalPlan;

  // Step navigation state
  int _currentStep = 0;
  final int totalSteps = 7;

  // Getters
  int get currentStep => _currentStep;
  String get levelValue => levelValueController.value ?? '';

  // Step navigation methods
  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Form field update methods
  void updateStartDate(String date) {
    startDateTextController.text = date;
    startDateError = null;
    notifyListeners();
  }

  void updateEndDate(String date) {
    endDateTextController.text = date;
    endDateError = null;
    notifyListeners();
  }

  void updateLevelValue(String? value) {
    if (value != null) {
      levelValueController.value = value;
      levelError = null;
      notifyListeners();
    }
  }

  void updateTrainingPlan(PlansRecord? plan) {
    selectedTrainingPlan = plan;
    trainingPlanController.value = plan?.plan.name;
    notifyListeners();
  }

  void updateNutritionalPlan(NutPlanRecord? plan) {
    selectedNutritionalPlan = plan;
    nutritionalPlanController.value = plan?.nutPlan.name;
    notifyListeners();
  }

  // Cleanup method
  @override
  void dispose() {
    emailTextController.dispose();
    nameTextController.dispose();
    goalTextController.dispose();
    paidTextController.dispose();
    debtsTextController.dispose();
    startDateTextController.dispose();
    endDateTextController.dispose();
    notesController.dispose();

    emailFocusNode.dispose();
    nameFocusNode.dispose();
    goalFocusNode.dispose();
    paidFocusNode.dispose();
    debtsFocusNode.dispose();
    startDateFocusNode.dispose();
    endDateFocusNode.dispose();
    notesFocusNode.dispose();

    super.dispose();
  }
}
