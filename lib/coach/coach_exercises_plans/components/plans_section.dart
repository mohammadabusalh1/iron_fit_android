import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../coach_exercises_plans_model.dart';
import 'plan_list_item.dart';

class PlansSection extends StatelessWidget {
  final List<PlansRecord> plans;
  final String title;
  final String countLabel;
  final bool isDraft;
  final VoidCallback loadData;

  const PlansSection({
    super.key,
    required this.plans,
    required this.title,
    required this.countLabel,
    this.isDraft = false,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final model = context.read<CoachExercisesPlansModel>();

    return Padding(
      padding: ResponsiveUtils.padding(
        context, 
        vertical: 12, 
        horizontal: 4
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCounter(context, theme),
          SizedBox(height: ResponsiveUtils.height(context, 12.0)),
          plans.isEmpty
              ? _buildEmptyState(context, theme)
              : _buildPlansList(context, model),
          SizedBox(height: ResponsiveUtils.height(context, 20)),
        ],
      ),
    ).animate().fade(duration: const Duration(milliseconds: 300));
  }

  Widget _buildCounter(BuildContext context, FlutterFlowTheme theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: ResponsiveUtils.padding(
          context,
          horizontal: 12,
          vertical: 4
        ),
        decoration: BoxDecoration(
          color: theme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.width(context, 12)
          ),
        ),
        child: Text(
          '${plans.length} $countLabel',
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14.0),
            color: theme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, FlutterFlowTheme theme) {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.padding(context, horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDraft
                  ? Icons.edit_note_outlined
                  : Icons.fitness_center_outlined,
              size: ResponsiveUtils.iconSize(context, 48),
              color: theme.secondaryText,
            ),
            SizedBox(height: ResponsiveUtils.height(context, 12)),
            Text(
              FFLocalizations.of(context).getText(
                isDraft ? 'no_draft_plans_found' : 'no_active_plans_found',
              ),
              textAlign: TextAlign.center,
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 14),
                color: theme.secondaryText,
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 16)),
            if (!isDraft)
              OutlinedButton.icon(
                onPressed: () => context.pushNamed('createExercisePlan'),
                icon: Icon(
                  Icons.add, 
                  color: theme.primary,
                  size: ResponsiveUtils.iconSize(context, 20),
                ),
                label: Text(
                  FFLocalizations.of(context).getText('create_plan'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    color: theme.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.width(context, 8)
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansList(BuildContext context, CoachExercisesPlansModel model) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < plans.length - 1 
              ? ResponsiveUtils.height(context, 12.0) 
              : 0
          ),
          child: PlanListItem(
            key: ValueKey(plan.reference.id),
            planItem: plan,
            index: index,
            onDelete: () => loadData(),
          ),
        );
      },
    );
  }
}
