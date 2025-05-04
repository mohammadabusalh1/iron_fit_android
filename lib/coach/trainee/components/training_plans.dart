import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/flutter_flow/form_field_controller.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
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
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary.withAlpha(40),
            width: 1,
          ),
        ),
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTrainingPlansHeader(context),
              SizedBox(height: ResponsiveUtils.height(context, 20)),
              _buildTrainingPlanSection(context),
              SizedBox(height: ResponsiveUtils.height(context, 16)),
              _buildNutritionalPlanSection(context),
              SizedBox(height: ResponsiveUtils.height(context, 12)),
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
          size: ResponsiveUtils.iconSize(context, 24),
        ),
        SizedBox(width: ResponsiveUtils.width(context, 12)),
        Text(
          FFLocalizations.of(context).getText('7ndmh9dh'),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 18),
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingPlanSection(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
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
                size: ResponsiveUtils.iconSize(context, 20),
                color: FlutterFlowTheme.of(context).primary,
              ),
              SizedBox(width: ResponsiveUtils.width(context, 8)),
              Text(
                FFLocalizations.of(context).getText('fgv70x81'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 12)),
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
                  padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
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
                        size: ResponsiveUtils.iconSize(context, 20),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      SizedBox(width: ResponsiveUtils.width(context, 8)),
                      Text(
                        FFLocalizations.of(context).getText('noPlansYet'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 14),
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
                            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(ResponsiveUtils.width(context, 24))),
                                      ),
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                          left: ResponsiveUtils.width(context, 20),
                                          right: ResponsiveUtils.width(context, 20),
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              ResponsiveUtils.height(context, 24),
                                          top: ResponsiveUtils.height(context, 24),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: ResponsiveUtils.width(context, 40),
                                                height: ResponsiveUtils.height(context, 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[400],
                                                  borderRadius:
                                                      BorderRadius.circular(ResponsiveUtils.width(context, 4)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText('selectPlan'),
                                              style: AppStyles.textCairo(
                                                context,
                                                fontSize: ResponsiveUtils.fontSize(context, 20),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            ...trainingPlanPlansRecordList.map(
                                              (plan) => Card(
                                                elevation: 2,
                                                margin:
                                                    EdgeInsets.symmetric(vertical: ResponsiveUtils.height(context, 6)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(ResponsiveUtils.width(context, 14)),
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(ResponsiveUtils.width(context, 14)),
                                                  onTap: () => Navigator.pop(
                                                      context, plan),
                                                  child: Padding(
                                                    padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 14),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .fitness_center_rounded,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            size: ResponsiveUtils.iconSize(context, 22)),
                                                        SizedBox(width: ResponsiveUtils.width(context, 12)),
                                                        Expanded(
                                                          child: Text(
                                                            plan.plan.name,
                                                            style: AppStyles
                                                                .textCairo(
                                                              context,
                                                              fontSize: ResponsiveUtils.fontSize(context, 16),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                            Icons
                                                                .chevron_right_rounded,
                                                            size: ResponsiveUtils.iconSize(context, 24)),
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
                                          .getText('selectTrainingPlan'),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: ResponsiveUtils.iconSize(context, 24),
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: ResponsiveUtils.height(context, 50),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    textStyle: AppStyles.textCairo(
                                      context,
                                      fontSize: ResponsiveUtils.fontSize(context, 14),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                    elevation: 0,
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                                  ),
                                );
                              }),
                        ),
                      ),
                      if (_selectedPlan != null)
                        Padding(
                          padding: EdgeInsets.only(left: ResponsiveUtils.width(context, 8.0)),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: FlutterFlowTheme.of(context).error,
                              size: ResponsiveUtils.iconSize(context, 24),
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
                      padding: EdgeInsets.only(top: ResponsiveUtils.height(context, 8.0)),
                      child: Container(
                        width: double.infinity,
                        padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 8)),
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
                              size: ResponsiveUtils.iconSize(context, 16),
                              color: FlutterFlowTheme.of(context).warning,
                            ),
                            SizedBox(width: ResponsiveUtils.width(context, 8)),
                            Expanded(
                              child: Text(
                                FFLocalizations.of(context)
                                    .getText('noPlanSelected'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: ResponsiveUtils.fontSize(context, 12),
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
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
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
                size: ResponsiveUtils.iconSize(context, 20),
                color: FlutterFlowTheme.of(context).primary,
              ),
              SizedBox(width: ResponsiveUtils.width(context, 8)),
              Text(
                FFLocalizations.of(context).getText('3cw2i9ua'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 12)),
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
                  padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
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
                        size: ResponsiveUtils.iconSize(context, 20),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      SizedBox(width: ResponsiveUtils.width(context, 8)),
                      Text(
                        FFLocalizations.of(context)
                            .getText('noNutritionalPlansYet'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 14),
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
                            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(ResponsiveUtils.width(context, 24))),
                                      ),
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                          left: ResponsiveUtils.width(context, 20),
                                          right: ResponsiveUtils.width(context, 20),
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              ResponsiveUtils.height(context, 24),
                                          top: ResponsiveUtils.height(context, 24),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: ResponsiveUtils.width(context, 40),
                                                height: ResponsiveUtils.height(context, 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[400],
                                                  borderRadius:
                                                      BorderRadius.circular(ResponsiveUtils.width(context, 4)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: ResponsiveUtils.height(context, 16)),
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText('selectPlan'),
                                              style: AppStyles.textCairo(
                                                context,
                                                fontSize: ResponsiveUtils.fontSize(context, 20),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: ResponsiveUtils.height(context, 20)),
                                            ...nutritionalPlanNutPlanRecordList
                                                .map(
                                              (plan) => Card(
                                                elevation: 3,
                                                margin:
                                                    EdgeInsets.symmetric(vertical: ResponsiveUtils.height(context, 6)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(ResponsiveUtils.width(context, 16)),
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                child: InkWell(
                                                  onTap: () => Navigator.pop(
                                                      context, plan),
                                                  borderRadius:
                                                      BorderRadius.circular(ResponsiveUtils.width(context, 16)),
                                                  splashColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                          .withOpacity(0.1),
                                                  child: Padding(
                                                    padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 14),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .restaurant_menu_rounded,
                                                          size: ResponsiveUtils.iconSize(context, 22),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                        ),
                                                        SizedBox(width: ResponsiveUtils.width(context, 12)),
                                                        Expanded(
                                                          child: Text(
                                                            plan.nutPlan.name,
                                                            style: AppStyles
                                                                .textCairo(
                                                              context,
                                                              fontSize: ResponsiveUtils.fontSize(context, 16),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                            Icons.chevron_right_rounded,
                                                            size: ResponsiveUtils.iconSize(context, 24)),
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
                                    size: ResponsiveUtils.iconSize(context, 24),
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: ResponsiveUtils.height(context, 50),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    textStyle: AppStyles.textCairo(
                                      context,
                                      fontSize: ResponsiveUtils.fontSize(context, 14),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                    elevation: 0,
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                                  ),
                                );
                              }),
                        ),
                      ),
                      if (_selectedNutPlan != null)
                        Padding(
                          padding: EdgeInsets.only(left: ResponsiveUtils.width(context, 8.0)),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: FlutterFlowTheme.of(context).error,
                              size: ResponsiveUtils.iconSize(context, 24),
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
                      padding: EdgeInsets.only(top: ResponsiveUtils.height(context, 8.0)),
                      child: Container(
                        width: double.infinity,
                        padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 8)),
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
                              size: ResponsiveUtils.iconSize(context, 16),
                              color: FlutterFlowTheme.of(context).warning,
                            ),
                            SizedBox(width: ResponsiveUtils.width(context, 8)),
                            Expanded(
                              child: Text(
                                FFLocalizations.of(context)
                                    .getText('noNutPlanSelected'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: ResponsiveUtils.fontSize(context, 12),
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
        size: ResponsiveUtils.iconSize(context, 22),
        color: theme.info,
      ),
      options: FFButtonOptions(
        width: double.infinity,
        height: ResponsiveUtils.height(context, 54.0),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.width(context, 16.0)),
        color: theme.primary.withOpacity(0.95),
        textStyle: AppStyles.textCairo(
          context,
          fontSize: ResponsiveUtils.fontSize(context, 14),
          fontWeight: FontWeight.w700,
          color: theme.info,
        ),
        elevation: 4,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
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
