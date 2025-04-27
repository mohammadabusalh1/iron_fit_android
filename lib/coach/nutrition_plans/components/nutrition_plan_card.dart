import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/componants/Styles.dart';

class NutritionPlanCard extends StatelessWidget {
  final NutPlanRecord plan;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onViewDetails;

  const NutritionPlanCard({
    super.key,
    required this.plan,
    required this.onDelete,
    required this.onEdit,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPlanHeader(context),
                  _buildPlanDetails(context),
                  _buildViewDetailsButton(context),
                ].divide(const SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Row _buildPlanHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.nutPlan.name,
              style: AppStyles.textCairo(context, fontSize: 16),
            ),
            Text(
              '${plan.nutPlan.numOfWeeks.toString()} ${FFLocalizations.of(context).getText('weeks' /* Weeks */)}',
              style: AppStyles.textCairo(
                context,
                fontSize: 14,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ),
        Row(
          children: [
            FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).primary,
              icon: Icon(
                Icons.edit_outlined,
                color: FlutterFlowTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: onEdit,
            ),
            const SizedBox(width: 8),
            FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).error,
              icon: Icon(
                Icons.delete_sharp,
                color: FlutterFlowTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }

  Row _buildPlanDetails(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).accent1,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Icon(
            Icons.restaurant_menu,
            color: FlutterFlowTheme.of(context).primary,
            size: 30.0,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${plan.nutPlan.meals.length.toString()} ${FFLocalizations.of(context).getText('meals' /* Meals */)}',
                style: AppStyles.textCairo(context, fontSize: 14),
              ),
              Text(
                plan.nutPlan.nots,
                style: AppStyles.textCairo(
                  context,
                  fontSize: 12,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
        ),
      ].divide(const SizedBox(width: 12.0)),
    );
  }

  FFButtonWidget _buildViewDetailsButton(BuildContext context) {
    return FFButtonWidget(
      onPressed: onViewDetails,
      text: FFLocalizations.of(context).getText('f0lulsew' /* View Details */),
      options: FFButtonOptions(
        width: MediaQuery.sizeOf(context).width,
        height: 40.0,
        padding: const EdgeInsets.all(0.0),
        iconPadding: const EdgeInsets.all(0.0),
        color: FlutterFlowTheme.of(context).primary,
        textStyle: AppStyles.textCairo(
          context,
          fontSize: 14,
          color: FlutterFlowTheme.of(context).info,
        ),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
