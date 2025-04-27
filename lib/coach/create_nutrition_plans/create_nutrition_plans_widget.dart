import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/logger.dart';

// Import components
import 'componants/header_section.dart';
import 'componants/plan_details_section.dart';
import 'componants/daily_macros_section.dart';
import 'componants/meal_schedule_section.dart';
import 'componants/additional_notes_section.dart';
import 'componants/submit_button_section.dart';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'create_nutrition_plans_model.dart';
export 'create_nutrition_plans_model.dart';

class CreateNutritionPlansWidget extends StatefulWidget {
  const CreateNutritionPlansWidget({
    super.key,
    this.editNutPlan,
  });

  final NutPlanRecord? editNutPlan;

  @override
  State<CreateNutritionPlansWidget> createState() =>
      _CreateNutritionPlansWidgetState();
}

class _CreateNutritionPlansWidgetState
    extends State<CreateNutritionPlansWidget> {
  late CreateNutritionPlansModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final Map<String, GlobalKey> _fieldKeys = {};
  bool get isEditing => widget.editNutPlan != null;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateNutritionPlansModel());
    _initializeControllers();
    _initializeFieldKeys();
    _populateFormIfEditing();
  }

  void _initializeControllers() {
    _model.nameTextController ??= TextEditingController();
    _model.nameFocusNode ??= FocusNode();
    _model.numOfWeeksTextController ??= TextEditingController();
    _model.numOfWeeksFocusNode ??= FocusNode();
    _model.proteinTextController ??= TextEditingController();
    _model.proteinFocusNode ??= FocusNode();
    _model.carbsTextController ??= TextEditingController();
    _model.carbsFocusNode ??= FocusNode();
    _model.fatsTextController ??= TextEditingController();
    _model.fatsFocusNode ??= FocusNode();
    _model.notesTextController ??= TextEditingController();
    _model.notesFocusNode ??= FocusNode();
    _model.caloriesTextController ??= TextEditingController();
    _model.caloriesFocusNode ??= FocusNode();
  }

  void _initializeFieldKeys() {
    _fieldKeys['name'] = GlobalKey();
    _fieldKeys['numOfWeeks'] = GlobalKey();
    _fieldKeys['protein'] = GlobalKey();
    _fieldKeys['carbs'] = GlobalKey();
    _fieldKeys['fats'] = GlobalKey();
    _fieldKeys['notes'] = GlobalKey();
    _fieldKeys['calories'] = GlobalKey();
  }

  void _populateFormIfEditing() {
    if (isEditing) {
      // Pre-populate the form with existing data
      _model.nameTextController.text = widget.editNutPlan!.nutPlan.name;
      if (widget.editNutPlan!.nutPlan.numOfWeeks != null) {
        _model.numOfWeeksTextController.text =
            widget.editNutPlan!.nutPlan.numOfWeeks.toString();
      }

      if (widget.editNutPlan!.nutPlan.protein != null) {
        _model.proteinTextController.text =
            widget.editNutPlan!.nutPlan.protein.toString();
      }

      if (widget.editNutPlan!.nutPlan.carbs != null) {
        _model.carbsTextController.text =
            widget.editNutPlan!.nutPlan.carbs.toString();
      }

      if (widget.editNutPlan!.nutPlan.fats != null) {
        _model.fatsTextController.text =
            widget.editNutPlan!.nutPlan.fats.toString();
      }

      if (widget.editNutPlan!.nutPlan.calories != null) {
        _model.caloriesTextController.text =
            widget.editNutPlan!.nutPlan.calories.toString();
      }

      _model.notesTextController.text = widget.editNutPlan!.nutPlan.nots;

      // Initialize the nutrition plan model with existing data
      _model.nutPlan = widget.editNutPlan!.nutPlan;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _handleMealAdded(MealStruct meal) {
    _model.updateNutPlanStruct((e) => e..updateMeals((e) => e.add(meal)));
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).unfocus();
    });
  }

  void _handleMealDeleted(MealStruct meal) {
    _model.updateNutPlanStruct(
        (e) => e..updateMeals((meals) => meals..remove(meal)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FlutterFlowTheme.of(context).primaryBackground,
                FlutterFlowTheme.of(context).success.withOpacity(0.3),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24.0),
                    HeaderSection(isEditing: isEditing),
                    PlanDetailsSection(
                      nameController: _model.nameTextController!,
                      nameFocusNode: _model.nameFocusNode!,
                      numOfWeeksController: _model.numOfWeeksTextController!,
                      numOfWeeksFocusNode: _model.numOfWeeksFocusNode!,
                      caloriesController: _model.caloriesTextController!,
                      caloriesFocusNode: _model.caloriesFocusNode!,
                      fieldKeys: _fieldKeys,
                    ),
                    DailyMacrosSection(
                      proteinController: _model.proteinTextController!,
                      proteinFocusNode: _model.proteinFocusNode!,
                      carbsController: _model.carbsTextController!,
                      carbsFocusNode: _model.carbsFocusNode!,
                      fatsController: _model.fatsTextController!,
                      fatsFocusNode: _model.fatsFocusNode!,
                    ),
                    MealScheduleSection(
                      nutPlan: _model.nutPlan,
                      onMealAdded: _handleMealAdded,
                      onMealDeleted: _handleMealDeleted,
                    ),
                    AdditionalNotesSection(
                      notesController: _model.notesTextController!,
                      notesFocusNode: _model.notesFocusNode!,
                    ),
                    SubmitButtonSection(
                      isEditing: isEditing,
                      onPressed: isEditing ? _updatePlan : _createPlan,
                    ),
                  ].divide(const SizedBox(height: 24.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createPlan() async {
    if (!_formKey.currentState!.validate()) {
      showErrorDialog(
          FFLocalizations.of(context).getText('emptyOrErrorFields'), context);
      return;
    }

    try {
      // Check for duplicate plan name
      if (!isEditing) {
        _model.nutPlanExist = await queryNutPlanRecordOnce(
          queryBuilder: (nutPlanRecord) => nutPlanRecord.where(
            'nutPlan.name',
            isEqualTo: _model.nameTextController.text,
          ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);

        if (_model.nutPlanExist != null) {
          throw Exception('Plan name is already in use.');
        }
      }

      await NutPlanRecord.collection.doc().set(createNutPlanRecordData(
            nutPlan: updateNutPlanStruct(
              NutPlanStruct(
                name: _model.nameTextController.text,
                numOfWeeks: int.tryParse(_model.numOfWeeksTextController.text),
                protein: int.tryParse(_model.proteinTextController.text),
                carbs: int.tryParse(_model.carbsTextController.text),
                fats: int.tryParse(_model.fatsTextController.text),
                meals: _model.nutPlan?.meals,
                nots: _model.notesTextController.text,
                calories: int.tryParse(_model.caloriesTextController.text),
              ),
              clearUnsetFields: false,
              create: true,
            ),
            coachRef: currentCoachDocument!.reference,
          ));

      context.pushNamed('NutritionPlans');
    } catch (e) {
      Logger.error('Error creating nutrition plan', e);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('failedToCreatePlan'), context);
      }
    }
  }

  Future<void> _updatePlan() async {
    if (!_formKey.currentState!.validate()) {
      showErrorDialog(
          FFLocalizations.of(context).getText('emptyOrErrorFields'), context);
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  FFLocalizations.of(context)
                      .getText('updatingPlan' /* Updating plan... */),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 16,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Check if plan name changed and if new name already exists
      if (widget.editNutPlan!.nutPlan.name != _model.nameTextController.text) {
        _model.nutPlanExist = await queryNutPlanRecordOnce(
          queryBuilder: (nutPlanRecord) => nutPlanRecord
              .where(
                'nutPlan.name',
                isEqualTo: _model.nameTextController.text,
              )
              .where(
                FieldPath.documentId,
                isNotEqualTo: widget.editNutPlan!.reference.id,
              ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);

        if (_model.nutPlanExist != null) {
          // Close loading dialog
          if (mounted) Navigator.pop(context);
          throw Exception('Plan name is already in use.');
        }
      }

      // Update the plan
      await widget.editNutPlan!.reference.update(createNutPlanRecordData(
        nutPlan: updateNutPlanStruct(
          NutPlanStruct(
            name: _model.nameTextController.text,
            numOfWeeks: int.tryParse(_model.numOfWeeksTextController.text),
            protein: int.tryParse(_model.proteinTextController.text),
            carbs: int.tryParse(_model.carbsTextController.text),
            fats: int.tryParse(_model.fatsTextController.text),
            meals: _model.nutPlan?.meals,
            nots: _model.notesTextController.text,
            calories: int.tryParse(_model.caloriesTextController.text),
          ),
          clearUnsetFields: false,
        ),
      ));

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Show success message
      if (mounted) {
        showSuccessDialog(
            FFLocalizations.of(context).getText('planUpdatedSuccessfully'),
            context);
      }

      context.pushNamed('NutritionPlans');
    } catch (e) {
      Logger.error('Error updating nutrition plan', e);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('failedToUpdatePlan'), context);
      }
    }
  }
}
