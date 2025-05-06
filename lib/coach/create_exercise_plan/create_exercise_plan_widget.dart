import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/utils/logger.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'create_exercise_plan_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'components/components.dart';
import '/utils/responsive_utils.dart';
export 'create_exercise_plan_model.dart';

/// Widget that memoizes the header section to prevent rebuilds
class MemoizedHeaderSection extends StatelessWidget {
  final bool isEditMode;

  const MemoizedHeaderSection({
    super.key,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return HeaderSection(
      isEditMode: isEditMode,
    ).animate().fadeIn(duration: 600.ms);
  }
}

/// Widget that memoizes plan details section to prevent rebuilds
class MemoizedPlanDetailsSection extends StatefulWidget {
  final TextEditingController planNameController;
  final FocusNode planNameFocusNode;
  final TextEditingController descController;
  final FocusNode descFocusNode;

  const MemoizedPlanDetailsSection({
    super.key,
    required this.planNameController,
    required this.planNameFocusNode,
    required this.descController,
    required this.descFocusNode,
  });

  @override
  State<MemoizedPlanDetailsSection> createState() =>
      _MemoizedPlanDetailsSectionState();
}

class _MemoizedPlanDetailsSectionState
    extends State<MemoizedPlanDetailsSection> {
  @override
  Widget build(BuildContext context) {
    return PlanDetailsSection(
      planNameController: widget.planNameController,
      planNameFocusNode: widget.planNameFocusNode,
      descController: widget.descController,
      descFocusNode: widget.descFocusNode,
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideX(begin: -0.1, end: 0);
  }

  @override
  void didUpdateWidget(MemoizedPlanDetailsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // We don't need to trigger a rebuild when the controllers are changed
    // because the text field widgets track their controllers internally
  }
}

/// Widget that memoizes program structure section to prevent rebuilds
class MemoizedProgramStructure extends StatefulWidget {
  final FormFieldController<List<String>> levelValueController;
  final FormFieldController<List<String>> goalValueController;
  final Function(List<String>?) onLevelChanged;
  final Function(List<String>?) onGoalChanged;

  const MemoizedProgramStructure({
    super.key,
    required this.levelValueController,
    required this.goalValueController,
    required this.onLevelChanged,
    required this.onGoalChanged,
  });

  @override
  State<MemoizedProgramStructure> createState() =>
      _MemoizedProgramStructureState();
}

class _MemoizedProgramStructureState extends State<MemoizedProgramStructure> {
  @override
  Widget build(BuildContext context) {
    return ProgramStructureSection(
      levelValueController: widget.levelValueController,
      goalValueController: widget.goalValueController,
      onLevelChanged: widget.onLevelChanged,
      onGoalChanged: widget.onGoalChanged,
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 600.ms)
        .slideX(begin: 0.1, end: 0);
  }

  @override
  void didUpdateWidget(MemoizedProgramStructure oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only rebuild if controllers change - note that we don't need to check
    // the callback functions since they shouldn't change during the lifecycle
    if (oldWidget.levelValueController != widget.levelValueController ||
        oldWidget.goalValueController != widget.goalValueController) {
      setState(() {});
    }
  }
}

/// A widget that efficiently caches its loading overlay unless props change
class MemoizedLoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final bool isSuccess;

  const MemoizedLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.isSuccess,
  });

  @override
  State<MemoizedLoadingOverlay> createState() => _MemoizedLoadingOverlayState();
}

class _MemoizedLoadingOverlayState extends State<MemoizedLoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: widget.isLoading,
      isSuccess: widget.isSuccess,
    );
  }

  @override
  void didUpdateWidget(MemoizedLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only rebuild when loading or success state changes
    if (oldWidget.isLoading != widget.isLoading ||
        oldWidget.isSuccess != widget.isSuccess) {
      setState(() {});
    }
  }
}

/// A widget that efficiently caches its child widgets when appropriate.
/// Caches the widget passed as [child] unless [draftPlan] changes.
class MemoizedPlanSchedule extends StatefulWidget {
  final PlanStruct? draftPlan;
  final GlobalKey dayKey;
  final Function(PlanStruct) onPlanUpdated;

  const MemoizedPlanSchedule({
    super.key,
    required this.draftPlan,
    required this.dayKey,
    required this.onPlanUpdated,
  });

  @override
  State<MemoizedPlanSchedule> createState() => _MemoizedPlanScheduleState();
}

class _MemoizedPlanScheduleState extends State<MemoizedPlanSchedule> {
  @override
  Widget build(BuildContext context) {
    return ScheduleSection(
      draftPlan: widget.draftPlan,
      dayKey: widget.dayKey,
      onPlanUpdated: widget.onPlanUpdated,
    );
  }

  @override
  void didUpdateWidget(MemoizedPlanSchedule oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only rebuild when plan data actually changes
    if (oldWidget.draftPlan != widget.draftPlan) {
      setState(() {});
    }
  }
}

/// Widget that memoizes the action buttons to prevent rebuilds
class MemoizedActionButtons extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onCreateOrUpdate;
  final VoidCallback? onSaveAsDraft;

  const MemoizedActionButtons({
    super.key,
    required this.isEditMode,
    required this.onCreateOrUpdate,
    this.onSaveAsDraft,
  });

  @override
  Widget build(BuildContext context) {
    return ActionButtons(
      isEditMode: isEditMode,
      onCreateOrUpdate: onCreateOrUpdate,
      onSaveAsDraft: onSaveAsDraft,
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 600.ms)
        .slideY(begin: 0.1, end: 0);
  }
}

class CreateExercisePlanWidget extends StatefulWidget {
  const CreateExercisePlanWidget({
    super.key,
    this.exercises,
    this.planRef,
    this.plan,
  });

  final List<ExerciseStruct>? exercises;
  final DocumentReference? planRef;
  final PlanStruct? plan;

  @override
  State<CreateExercisePlanWidget> createState() =>
      _CreateExercisePlanWidgetState();
}

class _CreateExercisePlanWidgetState extends State<CreateExercisePlanWidget> {
  late CreateExercisePlanModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey dayKey = GlobalKey();
  bool _isLoading = false;
  bool _isSuccess = false;
  bool get _isEditMode => widget.planRef != null && widget.plan != null;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateExercisePlanModel());
    _initializeControllers();
    if (_isEditMode) {
      _loadExistingPlan();
    }
  }

  /// Loads the existing plan details into the model's controllers and fields.
  /// This includes setting the plan name, description, level, type, and draft plan
  /// from the provided widget plan, if available. Initializes form field controllers
  /// for level and type with existing values.

  void _loadExistingPlan() {
    _model.planNameTextController.text = widget.plan?.name ?? '';
    _model.descTextController.text = widget.plan?.description ?? '';
    _model.levelValue = widget.plan?.level;
    _model.levelValueController = FormFieldController(
        widget.plan?.level != null ? [widget.plan!.level] : []);
    _model.goalValue = widget.plan?.type;
    _model.goalValueController = FormFieldController(
        widget.plan?.type != null ? [widget.plan!.type] : []);
    _model.draftPlan = widget.plan;
  }

  void _initializeControllers() {
    _model.planNameTextController ??= TextEditingController();
    _model.planNameFocusNode ??= FocusNode();
    _model.descTextController ??= TextEditingController();
    _model.descFocusNode ??= FocusNode();

    // Initialize FormFieldControllers to prevent null check errors
    _model.levelValueController ??= FormFieldController<List<String>>([]);
    _model.goalValueController ??= FormFieldController<List<String>>([]);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentCoachDocument == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('Login');
        }
      });
      return const LoadingIndicator();
    }
    return Stack(
      children: [
        _buildMainScreen(currentCoachDocument!),
        MemoizedLoadingOverlay(
          isLoading: _isLoading,
          isSuccess: _isSuccess,
        ),
      ],
    );
  }

  Widget _buildMainScreen(CoachRecord coachRecord) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4B39EF), Color(0xFF3700B3)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Padding(
            padding: ResponsiveUtils.padding(
              context,
              horizontal: 24.0,
              vertical: 0.0,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveUtils.height(context, 24.0)),
                    MemoizedHeaderSection(
                      isEditMode: _isEditMode,
                    ),
                    MemoizedPlanDetailsSection(
                      planNameController: _model.planNameTextController!,
                      planNameFocusNode: _model.planNameFocusNode!,
                      descController: _model.descTextController!,
                      descFocusNode: _model.descFocusNode!,
                    ),
                    MemoizedProgramStructure(
                      levelValueController: _model.levelValueController ??
                          FormFieldController<List<String>>([]),
                      goalValueController: _model.goalValueController ??
                          FormFieldController<List<String>>([]),
                      onLevelChanged: (val) {
                        if (_model.levelValue != val?.firstOrNull) {
                          setState(() {
                            _model.levelValue = val?.firstOrNull;
                          });
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              FocusScope.of(context).unfocus();
                            }
                          });
                        }
                      },
                      onGoalChanged: (val) {
                        if (_model.goalValue != val?.firstOrNull) {
                          setState(() => _model.goalValue = val?.firstOrNull);
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              FocusScope.of(context).unfocus();
                            }
                          });
                        }
                      },
                    ),
                    MemoizedPlanSchedule(
                      draftPlan: _model.draftPlan,
                      dayKey: dayKey,
                      onPlanUpdated: (updatedPlan) {
                        if (_model.draftPlan != updatedPlan && mounted) {
                          setState(() {
                            _model.draftPlan = updatedPlan;
                          });
                        }
                      },
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideX(begin: -0.1, end: 0),
                    MemoizedActionButtons(
                      isEditMode: _isEditMode,
                      onCreateOrUpdate: () => _isEditMode
                          ? _updatePlan(coachRecord)
                          : _createPlan(coachRecord),
                      onSaveAsDraft:
                          !_isEditMode ? () => _saveAsDraft(coachRecord) : null,
                    ),
                    SizedBox(height: ResponsiveUtils.height(context, 24.0)),
                  ].divide(
                      SizedBox(height: ResponsiveUtils.height(context, 24.0))),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createPlan(coachRecord) async {
    try {
      if (_formKey.currentState!.validate()) {
        _model.planExist = await queryPlansRecordOnce(
          queryBuilder: (plansRecord) => plansRecord
              .where('plan.coach', isEqualTo: coachRecord.reference)
              .where(
                'plan.name',
                isEqualTo: _model.planNameTextController.text,
              ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);

        if (_model.planExist != null) {
          functions.showErrorDialog(
              FFLocalizations.of(context).getText('planNameUsed'), context);
        } else if (_model.levelValue == null || _model.levelValue!.isEmpty) {
          functions.showErrorDialog(
              FFLocalizations.of(context).getText('selectLevel'), context);
        } else if (_model.goalValue == null || _model.goalValue!.isEmpty) {
          functions.showErrorDialog(
              FFLocalizations.of(context).getText('goalIsRequired'), context);
        } else {
          _createPlanRecord(coachRecord);
        }
      } else {
        functions.showErrorDialog(
            FFLocalizations.of(context).getText('emptyOrErrorFields'), context);
      }
    } catch (e, stackTrace) {
      Logger.error('Error creating plan: $e', e, stackTrace);
      functions.showErrorDialog(
          FFLocalizations.of(context).getText('failedToCreatePlan'), context);
    }
  }

  Future<void> _createPlanRecord(CoachRecord coachRecord) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Calculate total rounds and repetitions for each day
      int totalSource = 0;

      for (TrainingDayStruct day in _model.draftPlan?.days ?? []) {
        int daySource = 0;

        for (ExerciseStruct exercise in day.exercises) {
          if (exercise.reps == 0 && exercise.time > 0) {
            daySource += exercise.sets * exercise.time;
          } else {
            daySource += exercise.sets * exercise.reps;
          }
        }
        // Add a source to each day
        day.source = daySource;
        totalSource += daySource;
      }

      try {
        await PlansRecord.collection.doc().set(createPlansRecordData(
              plan: updatePlanStruct(
                PlanStruct(
                  name: _model.planNameTextController.text,
                  level: _model.levelValue,
                  coach: coachRecord.reference,
                  createdAt: getCurrentTimestamp,
                  description: _model.descTextController.text,
                  draft: false,
                  days: _model.draftPlan?.days,
                  totalSource: totalSource, // Add total source to the plan
                  type: _model.goalValue,
                ),
                clearUnsetFields: false,
                create: true,
              ),
            ));

        // Wait for success animation
        await Future.delayed(const Duration(seconds: 1));

        setState(() {
          _isSuccess = true;
        });

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          context.pushNamed('CoachExercisesPlans');
        }
      } on FirebaseException catch (e, stackTrace) {
        Logger.error('Firebase error creating plan: [${e.code}] ${e.message}',
            e, stackTrace);
        if (mounted) {
          String errorMessage =
              FFLocalizations.of(context).getText('failedToCreatePlan');
          // Provide more specific error messages based on Firebase error codes
          if (e.code == 'permission-denied') {
            errorMessage =
                FFLocalizations.of(context).getText('permissionDenied');
          } else if (e.code == 'network-request-failed') {
            errorMessage = FFLocalizations.of(context).getText('networkError');
          }
          functions.showErrorDialog(errorMessage, context);
        }
      } catch (e, stackTrace) {
        Logger.error('Error creating plan record: $e', e, stackTrace);
        if (mounted) {
          functions.showErrorDialog(
              FFLocalizations.of(context).getText('failedToCreatePlan'),
              context);
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Error in _createPlanRecord: $e', e, stackTrace);
      if (mounted) {
        functions.showErrorDialog(
            FFLocalizations.of(context).getText('failedToCreatePlan'), context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = false;
        });
      }
    }
  }

  Future<void> _saveAsDraft(createExercisePlanCoachRecord) async {
    try {
      await PlansRecord.collection.doc().set(createPlansRecordData(
            plan: updatePlanStruct(
              PlanStruct(
                name: _model.planNameTextController.text,
                level: _model.levelValue,
                coach: createExercisePlanCoachRecord?.reference,
                createdAt: functions.nowDate(),
                description: _model.descTextController.text,
                draft: true,
                days: _model.draftPlan?.days,
                type: _model.goalValue,
              ),
              clearUnsetFields: false,
              create: true,
            ),
          ));
      if (mounted) {
        context.pushNamed('CoachExercisesPlans');
      }
    } on FirebaseException catch (e, stackTrace) {
      Logger.error('Firebase error saving draft: [${e.code}] ${e.message}', e,
          stackTrace);
      if (mounted) {
        String errorMessage =
            FFLocalizations.of(context).getText('failedToSaveDraft');
        if (e.code == 'permission-denied') {
          errorMessage =
              FFLocalizations.of(context).getText('permissionDenied');
        }
        functions.showErrorDialog(errorMessage, context);
      }
    } catch (e, stackTrace) {
      Logger.error('Error saving draft: $e', e, stackTrace);
      if (mounted) {
        functions.showErrorDialog(
            FFLocalizations.of(context).getText('failedToSaveDraft'), context);
      }
    }
  }

  Future<void> _updatePlan(CoachRecord coachRecord) async {
    try {
      if (_formKey.currentState!.validate()) {
        _model.planExist = await queryPlansRecordOnce(
          queryBuilder: (plansRecord) => plansRecord
              .where(
                'plan.name',
                isEqualTo: _model.planNameTextController.text,
              )
              .where(
                'reference',
                isNotEqualTo: widget.planRef,
              ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);

        if (_model.planExist != null) {
          functions.showErrorDialog(
              FFLocalizations.of(context).getText('planNameUsed'), context);
        } else if (_model.levelValue == null || _model.levelValue!.isEmpty) {
          functions.showErrorDialog(
              FFLocalizations.of(context).getText('selectLevel'), context);
        } else if (_model.goalValue == null || _model.goalValue!.isEmpty) {
          functions.showErrorDialog(
              FFLocalizations.of(context).getText('goalIsRequired'), context);
        } else {
          _updatePlanRecord(coachRecord);
        }
      } else {
        functions.showErrorDialog(
            FFLocalizations.of(context).getText('emptyOrErrorFields'), context);
      }
    } catch (e, stackTrace) {
      Logger.error('Error updating plan: $e', e, stackTrace);
      functions.showErrorDialog(
          FFLocalizations.of(context).getText('2184r6dy'), context);
    }
  }

  Future<void> _updatePlanRecord(CoachRecord coachRecord) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Calculate total rounds and repetitions for each day
      int totalSource = 0;

      for (TrainingDayStruct day in _model.draftPlan?.days ?? []) {
        int daySource = 0;

        for (ExerciseStruct exercise in day.exercises) {
          if (exercise.reps == 0 && exercise.time > 0) {
            daySource += exercise.sets * exercise.time;
          } else {
            daySource += exercise.sets * exercise.reps;
          }
        }
        // Add a source to each day
        day.source = daySource;
        totalSource += daySource;
      }

      try {
        await widget.planRef!.update(createPlansRecordData(
          plan: updatePlanStruct(
            PlanStruct(
              name: _model.planNameTextController.text,
              level: _model.levelValue,
              coach: coachRecord.reference,
              createdAt: widget.plan?.createdAt,
              description: _model.descTextController.text,
              draft: false,
              days: _model.draftPlan?.days,
              totalSource: totalSource,
              type: _model.goalValue,
            ),
            clearUnsetFields: false,
            create: false,
          ),
        ));

        // Wait for success animation
        await Future.delayed(const Duration(seconds: 1));

        setState(() {
          _isSuccess = true;
        });

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          context.pushNamed('CoachExercisesPlans');
        }
      } on FirebaseException catch (e, stackTrace) {
        Logger.error('Firebase error updating plan: [${e.code}] ${e.message}',
            e, stackTrace);
        if (mounted) {
          String errorMessage =
              FFLocalizations.of(context).getText('failedToUpdatePlan');
          // Provide more specific error messages based on Firebase error codes
          if (e.code == 'permission-denied') {
            errorMessage =
                FFLocalizations.of(context).getText('permissionDenied');
          } else if (e.code == 'not-found') {
            errorMessage = FFLocalizations.of(context).getText('planNotFound');
          }
          functions.showErrorDialog(errorMessage, context);
        }
      } catch (e, stackTrace) {
        Logger.error('Error updating plan record: $e', e, stackTrace);
        if (mounted) {
          functions.showErrorDialog(
              FFLocalizations.of(context).getText('failedToUpdatePlan'),
              context);
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Error in _updatePlanRecord: $e', e, stackTrace);
      if (mounted) {
        functions.showErrorDialog(
            FFLocalizations.of(context).getText('failedToUpdatePlan'), context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = false;
        });
      }
    }
  }
}
