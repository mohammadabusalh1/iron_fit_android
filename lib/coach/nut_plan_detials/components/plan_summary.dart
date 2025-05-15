import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
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
        borderRadius:
            BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withAlpha(30),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.width(context, 20.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _PlanInfo(),
            Divider(height: ResponsiveUtils.height(context, 32.0)),
            const _NutrientInfo(),
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
          crossAxisAlignment: CrossAxisAlignment.start, // Align vertically
          children: [
            Expanded(
              // Allow text column to take up available space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valueOrDefault<String>(
                      nuPlan.nutPlan.name,
                      FFLocalizations.of(context)
                          .getText('aj70rhi0'), // Default value
                    ),
                    maxLines: null, // Unlimited lines
                    softWrap: true, // Allow wrapping
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 8)),
                  Wrap(
                    spacing: ResponsiveUtils.width(context, 12),
                    runSpacing: ResponsiveUtils.height(context, 12),
                    children: [
                      Text(
                        '${nuPlan.nutPlan.numOfWeeks} ${FFLocalizations.of(context).getText('weeks')}',
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 12),
                        ),
                      ),
                      Text(
                        '${nuPlan.nutPlan.calories} ${FFLocalizations.of(context).getText('calories')}',
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 12),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        if (nuPlan.nutPlan.nots != null && nuPlan.nutPlan.nots.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUtils.height(context, 8.0)),
            child: Text(
              nuPlan.nutPlan.nots,
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).info.withOpacity(0.7),
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
      spacing: ResponsiveUtils.width(context, 12),
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
