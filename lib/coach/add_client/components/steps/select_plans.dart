import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_drop_down.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iron_fit/coach/add_client/add_client_model.dart';
import '/auth/firebase_auth/auth_util.dart';

class SelectPlans extends StatefulWidget {
  final AddClientModel model;
  final bool isFirstStep;

  const SelectPlans({
    super.key,
    required this.model,
    required this.isFirstStep,
  });

  @override
  State<SelectPlans> createState() => _SelectPlansState();
}

class _SelectPlansState extends State<SelectPlans> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(
        top: 24,
        bottom: 24,
        left: widget.isFirstStep ? 0 : 16,
        right: widget.isFirstStep ? 0 : 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            FFLocalizations.of(context).getText('select_plans_title'),
            style: AppStyles.textCairo(
              context,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          Text(
            FFLocalizations.of(context).getText('select_plans_description'),
            style: AppStyles.textCairo(
              context,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          const SizedBox(height: 32),
          _buildTrainingPlanSection(context),
          const SizedBox(height: 24),
          _buildNutritionalPlanSection(context),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).moveY(
          begin: 20,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildTrainingPlanSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.fitness_center_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              FFLocalizations.of(context).getText('fgv70x81'),
              style: AppStyles.textCairo(
                context,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate.withAlpha(120),
            ),
          ),
          child: FutureBuilder<List<PlansRecord>>(
            future: queryPlansRecordOnce(
              queryBuilder: (plansRecord) => plansRecord
                  .where('plan.coach',
                      isEqualTo: currentCoachDocument!.reference)
                  .where('plan.draft', isEqualTo: false),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  )),
                );
              }

              List<PlansRecord> trainingPlans = snapshot.data!;

              if (trainingPlans.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      FFLocalizations.of(context).getText('noPlansYet'),
                      style: AppStyles.textCairo(
                        context,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: FlutterFlowDropDown<String>(
                  controller: widget.model.trainingPlanController,
                  options: trainingPlans.map((plan) => plan.plan.name).toList(),
                  onChanged: (val) async {
                    if (val == null) return;

                    final selectedPlan = trainingPlans.firstWhere(
                      (plan) => plan.plan.name == val,
                      orElse: () => trainingPlans.first,
                    );

                    widget.model.updateTrainingPlan(selectedPlan);
                  },
                  width: double.infinity,
                  height: 50,
                  textStyle: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                  hintText: FFLocalizations.of(context).getText('select_plan'),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24,
                  ),
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 2,
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  borderRadius: 8,
                  margin: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                  hidesUnderline: true,
                  isSearchable: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalPlanSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              FFLocalizations.of(context).getText('zs7ls2wz'),
              style: AppStyles.textCairo(
                context,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate.withAlpha(120),
            ),
          ),
          child: FutureBuilder<List<NutPlanRecord>>(
            future: queryNutPlanRecordOnce(
              queryBuilder: (nutPlanRecord) => nutPlanRecord.where('coachRef',
                  isEqualTo: currentCoachDocument!.reference),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  )),
                );
              }

              List<NutPlanRecord> nutritionPlans = snapshot.data!;

              if (nutritionPlans.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      FFLocalizations.of(context)
                          .getText('nutritionPlanNotFound'),
                      style: AppStyles.textCairo(
                        context,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: FlutterFlowDropDown<String>(
                  controller: widget.model.nutritionalPlanController,
                  options:
                      nutritionPlans.map((plan) => plan.nutPlan.name).toList(),
                  onChanged: (val) async {
                    if (val == null) return;

                    final selectedPlan = nutritionPlans.firstWhere(
                      (plan) => plan.nutPlan.name == val,
                      orElse: () => nutritionPlans.first,
                    );

                    widget.model.updateNutritionalPlan(selectedPlan);
                  },
                  width: double.infinity,
                  height: 50,
                  textStyle: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                  hintText: FFLocalizations.of(context)
                      .getText('select_nutrition_plan'),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24,
                  ),
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 2,
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  borderRadius: 8,
                  margin: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                  hidesUnderline: true,
                  isSearchable: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
