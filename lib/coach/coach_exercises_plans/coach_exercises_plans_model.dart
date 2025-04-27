import '/flutter_flow/flutter_flow_util.dart';
import 'coach_exercises_plans_widget.dart' show CoachExercisesPlansWidget;
import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:provider/provider.dart';

class CoachExercisesPlansModel
    extends FlutterFlowModel<CoachExercisesPlansWidget> with ChangeNotifier {
  // State properties
  CoachRecord? coach;
  List<PlansRecord> activePlans = [];
  List<PlansRecord> draftPlans = [];
  bool isLoading = true;
  String? errorMessage;

  // Methods to update state
  void updateCoach(CoachRecord value) {
    coach = value;
    notifyListeners();
  }

  void updatePlans(List<PlansRecord> plans) {
    activePlans = plans.where((plan) => plan.plan.draft == false).toList();
    draftPlans = plans.where((plan) => plan.plan.draft == true).toList();
    isLoading = false;
    notifyListeners();
  }

  void setError(String? message) {
    errorMessage = message;
    isLoading = false;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void refresh() {
    errorMessage = null;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    onUpdate();
  }

  @override
  void initState(BuildContext context) {}

  static CoachExercisesPlansModel of(BuildContext context) {
    return Provider.of<CoachExercisesPlansModel>(context, listen: false);
  }
}
