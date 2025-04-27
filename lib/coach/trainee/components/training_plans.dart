import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/flutter_flow/form_field_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A component for managing trainee's training and nutritional plans.
class TrainingPlansWidget extends StatefulWidget {
  final SubscriptionsRecord subscription;
  final CoachRecord coachRecord;
  final FormFieldController<String>? trainingPlanController;
  final FormFieldController<String>? nutritionalPlanController;
  final ValueChanged<PlansRecord?> onTrainingPlanChanged;
  final ValueChanged<NutPlanRecord?> onNutritionalPlanChanged;
  final VoidCallback onDeleteTrainingPlan;
  final VoidCallback onDeleteNutritionalPlan;
  final VoidCallback onSavePlans;

  const TrainingPlansWidget({
    super.key,
    required this.subscription,
    required this.coachRecord,
    this.trainingPlanController,
    this.nutritionalPlanController,
    required this.onTrainingPlanChanged,
    required this.onNutritionalPlanChanged,
    required this.onDeleteTrainingPlan,
    required this.onDeleteNutritionalPlan,
    required this.onSavePlans,
  });

  @override
  State<TrainingPlansWidget> createState() => _TrainingPlansWidgetState();
}

class _TrainingPlansWidgetState extends State<TrainingPlansWidget> {
  late DocumentReference? _selectedPlan;
  late DocumentReference? _selectedNutPlan;

  @override
  void initState() {
    super.initState();
    _selectedPlan = widget.subscription.plan;
    _selectedNutPlan = widget.subscription.nutPlan;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary.withAlpha(40),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTrainingPlansHeader(context),
              const SizedBox(height: 20),
              _buildTrainingPlanSection(context),
              const SizedBox(height: 16),
              _buildNutritionalPlanSection(context),
              const SizedBox(height: 12),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms).moveY(
          begin: 50,
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildTrainingPlansHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.fitness_center_rounded,
          color: FlutterFlowTheme.of(context).primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          FFLocalizations.of(context).getText('7ndmh9dh'),
          style: AppStyles.textCairo(
            context,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingPlanSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate.withAlpha(120),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.directions_run_rounded,
                size: 20,
                color: FlutterFlowTheme.of(context).primary,
              ),
              const SizedBox(width: 8),
              Text(
                FFLocalizations.of(context).getText('fgv70x81'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<PlansRecord>>(
            future: queryPlansRecordOnce(
              queryBuilder: (plansRecord) => plansRecord
                  .where('plan.coach', isEqualTo: widget.coachRecord.reference)
                  .where('plan.draft', isEqualTo: false),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoadingIndicator();
              }

              List<PlansRecord> trainingPlanPlansRecordList = snapshot.data!;

              if (trainingPlanPlansRecordList.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          FlutterFlowTheme.of(context).alternate.withAlpha(120),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        FFLocalizations.of(context).getText('noPlansYet'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .alternate
                                  .withAlpha(120),
                            ),
                          ),
                          child: FutureBuilder<String>(
                              future: _getPlanName(context, _selectedPlan),
                              builder: (context, snapshot) {
                                return FFButtonWidget(
                                  onPressed: () async {
                                    final selectedPlan =
                                        await showModalBottomSheet<PlansRecord>(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24)),
                                      ),
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              24,
                                          top: 24,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: 40,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[400],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText('selectPlan'),
                                              style: AppStyles.textCairo(
                                                context,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            ...trainingPlanPlansRecordList.map(
                                              (plan) => Card(
                                                elevation: 2,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  onTap: () => Navigator.pop(
                                                      context, plan),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16,
                                                      vertical: 14,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .fitness_center_rounded,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            size: 22),
                                                        const SizedBox(
                                                            width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            plan.plan.name,
                                                            style: AppStyles
                                                                .textCairo(
                                                              context,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                            ),
                                                          ),
                                                        ),
                                                        const Icon(
                                                            Icons
                                                                .chevron_right_rounded,
                                                            size: 24),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                    if (selectedPlan != null) {
                                      widget
                                          .onTrainingPlanChanged(selectedPlan);
                                      setState(() {
                                        _selectedPlan = selectedPlan.reference;
                                      });
                                    }
                                  },
                                  text: snapshot.data ??
                                      FFLocalizations.of(context)
                                          .getText('selectPlan'),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24,
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    textStyle: AppStyles.textCairo(
                                      context,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                    elevation: 0,
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                );
                              }),
                        ),
                      ),
                      if (_selectedPlan != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: FlutterFlowTheme.of(context).error,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedPlan = null;
                              });
                              widget.onDeleteTrainingPlan();
                            },
                          ),
                        ),
                    ],
                  ),
                  if (_selectedPlan == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context)
                                .warning
                                .withAlpha(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: FlutterFlowTheme.of(context).warning,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                FFLocalizations.of(context)
                                    .getText('noPlanSelected'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: 12,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<String> _getPlanName(
      BuildContext context, DocumentReference? planRef) async {
    if (planRef == null)
      return FFLocalizations.of(context).getText('selectPlan');
    final plan = await PlansRecord.getDocumentOnce(planRef);
    return plan.plan.name;
  }

  Widget _buildNutritionalPlanSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate.withAlpha(120),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_menu_rounded,
                size: 20,
                color: FlutterFlowTheme.of(context).primary,
              ),
              const SizedBox(width: 8),
              Text(
                FFLocalizations.of(context).getText('3cw2i9ua'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<NutPlanRecord>>(
            future: queryNutPlanRecordOnce(
              queryBuilder: (nutPlanRecord) => nutPlanRecord.where(
                'coachRef',
                isEqualTo: widget.coachRecord.reference,
              ),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoadingIndicator();
              }

              List<NutPlanRecord> nutritionalPlanNutPlanRecordList =
                  snapshot.data!;

              if (nutritionalPlanNutPlanRecordList.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          FlutterFlowTheme.of(context).alternate.withAlpha(120),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        FFLocalizations.of(context)
                            .getText('noNutritionalPlansYet'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .alternate
                                  .withAlpha(120),
                            ),
                          ),
                          child: FutureBuilder<String>(
                              future:
                                  _getNutPlanName(context, _selectedNutPlan),
                              builder: (context, snapshot) {
                                return FFButtonWidget(
                                  onPressed: () async {
                                    final selectedPlan =
                                        await showModalBottomSheet<
                                            NutPlanRecord>(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24)),
                                      ),
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              24,
                                          top: 24,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: 40,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[400],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText('selectPlan'),
                                              style: AppStyles.textCairo(
                                                context,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            ...nutritionalPlanNutPlanRecordList
                                                .map(
                                              (plan) => Card(
                                                elevation: 3,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                child: InkWell(
                                                  onTap: () => Navigator.pop(
                                                      context, plan),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  splashColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                          .withOpacity(0.1),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 14),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .restaurant_menu_rounded,
                                                          size: 22,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                        ),
                                                        const SizedBox(
                                                            width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            plan.nutPlan.name,
                                                            style: AppStyles
                                                                .textCairo(
                                                              context,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                            ),
                                                          ),
                                                        ),
                                                        const Icon(
                                                            Icons
                                                                .chevron_right_rounded,
                                                            size: 24),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                    if (selectedPlan != null) {
                                      widget.onNutritionalPlanChanged(
                                          selectedPlan);
                                      setState(() {
                                        _selectedNutPlan =
                                            selectedPlan.reference;
                                      });
                                    }
                                  },
                                  text: snapshot.data ??
                                      FFLocalizations.of(context)
                                          .getText('selectPlan'),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24,
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    textStyle: AppStyles.textCairo(
                                      context,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                    elevation: 0,
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                );
                              }),
                        ),
                      ),
                      if (_selectedNutPlan != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: FlutterFlowTheme.of(context).error,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedNutPlan = null;
                              });
                              widget.onDeleteNutritionalPlan();
                            },
                          ),
                        ),
                    ],
                  ),
                  if (_selectedNutPlan == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context)
                                .warning
                                .withAlpha(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: FlutterFlowTheme.of(context).warning,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                FFLocalizations.of(context)
                                    .getText('noNutPlanSelected'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: 12,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<String> _getNutPlanName(
      BuildContext context, DocumentReference? planRef) async {
    if (planRef == null)
      return FFLocalizations.of(context).getText('selectPlan');
    final plan = await NutPlanRecord.getDocumentOnce(planRef);
    return plan.nutPlan.name;
  }

  Widget _buildSaveButton(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FFButtonWidget(
      onPressed: widget.onSavePlans,
      text: FFLocalizations.of(context).getText('savePlans'),
      icon: Icon(
        Icons.save_rounded,
        size: 22,
        color: theme.info,
      ),
      options: FFButtonOptions(
        width: double.infinity,
        height: 54.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: theme.primary.withOpacity(0.95),
        textStyle: AppStyles.textCairo(
          context,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: theme.info,
        ),
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 250.ms, curve: Curves.easeInOut)
        .scale(
          duration: 250.ms,
          curve: Curves.easeOutBack,
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
        )
        .shimmer(
          duration: 1200.ms,
          color: FlutterFlowTheme.of(context).primary.withAlpha(80),
        );
  }
}
