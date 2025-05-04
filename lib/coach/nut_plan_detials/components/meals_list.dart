import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iron_fit/coach/nut_plan_detials/components/meal_item.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MealsList extends StatelessWidget {
  final NutPlanRecord nuPlan;

  const MealsList({
    super.key,
    required this.nuPlan,
  });

  @override
  Widget build(BuildContext context) {
    if (nuPlan.nutPlan.meals.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        SizedBox(height: ResponsiveUtils.height(context, 16)),
        _buildMeals(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: ResponsiveUtils.height(context, MediaQuery.of(context).size.height * 0.5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_meals_outlined,
              size: ResponsiveUtils.iconSize(context, 64),
              color: FlutterFlowTheme.of(context).secondaryText,
            ).animate().scale(duration: 400.ms).then().shake(duration: 400.ms),
            SizedBox(height: ResponsiveUtils.height(context, 16)),
            Text(
              FFLocalizations.of(context).getText('no_active_plans_found'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 18),
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          FFLocalizations.of(context).getText('awy23yqq' /* Today's Meals */),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 18),
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.width(context, 12), 
            vertical: ResponsiveUtils.height(context, 6)
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary.withAlpha(30),
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 20)),
          ),
          child: Text(
            '${nuPlan.nutPlan.meals.length} ${FFLocalizations.of(context).getText('meals')}',
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: FlutterFlowTheme.of(context).primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeals(BuildContext context) {
    final meals = nuPlan.nutPlan.meals.toList();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(meals.length, (index) {
        return MealItem(
          key: ValueKey('meal-${meals[index].name}-$index'),
          meal: meals[index],
        );
      }),
    );
  }
}
