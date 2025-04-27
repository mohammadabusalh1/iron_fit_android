import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'nutrient_card.dart';

class PlanSummary extends StatelessWidget {
  final NutPlanRecord nuPlan;

  const PlanSummary({
    super.key,
    required this.nuPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary.withAlpha(60),
            FlutterFlowTheme.of(context).secondary.withAlpha(120),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withAlpha(30),
          width: 1.0,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PlanInfo(),
            Divider(height: 32.0),
            _NutrientInfo(),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 400.ms, delay: 200.ms)
        .slideX(begin: -0.1, end: 0);
  }
}

class _PlanInfo extends StatelessWidget {
  const _PlanInfo();

  @override
  Widget build(BuildContext context) {
    final nuPlan = context.findAncestorWidgetOfExactType<PlanSummary>()!.nuPlan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valueOrDefault<String>(nuPlan.nutPlan.name,
                      FFLocalizations.of(context).getText('aj70rhi0')),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${nuPlan.nutPlan.numOfWeeks.toString()} ${FFLocalizations.of(context).getText('weeks')}',
                  style: AppStyles.textCairo(context, fontSize: 12),
                ),
                Text(
                  '${nuPlan.nutPlan.calories != null ? nuPlan.nutPlan.calories.toString() : 0} ${FFLocalizations.of(context).getText('calories')}',
                  style: AppStyles.textCairo(context, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        if (nuPlan.nutPlan.nots != null && nuPlan.nutPlan.nots.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              nuPlan.nutPlan.nots,
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ),
      ],
    );
  }
}

class _NutrientInfo extends StatelessWidget {
  const _NutrientInfo();

  @override
  Widget build(BuildContext context) {
    final nuPlan = context.findAncestorWidgetOfExactType<PlanSummary>()!.nuPlan;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 12,
      children: [
        NutrientCard(
          localizationKey: '7o3ns13g',
          value: nuPlan.nutPlan.carbs,
          icon: Icons.grain,
        ),
        NutrientCard(
          localizationKey: 'ys94uz5z',
          value: nuPlan.nutPlan.protein,
          icon: Icons.fitness_center,
        ),
        NutrientCard(
          localizationKey: '04a440i9',
          value: nuPlan.nutPlan.fats,
          icon: Icons.water_drop,
        ),
      ],
    );
  }
}
