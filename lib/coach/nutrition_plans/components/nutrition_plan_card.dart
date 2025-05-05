import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

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
            borderRadius:
                BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius:
                  BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
            ),
            child: Padding(
              padding: ResponsiveUtils.padding(context,
                  horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPlanHeader(context),
                  _buildPlanDetails(context),
                  _buildViewDetailsButton(context),
                ].divide(
                    SizedBox(height: ResponsiveUtils.height(context, 16.0))),
              ),
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 16.0)),
      ],
    );
  }

  Row _buildPlanHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          CrossAxisAlignment.start, // Add this for vertical alignment
      children: [
        Expanded(
          // Allow the left side to take up available space
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.nutPlan.name,
                maxLines: null, // Allow unlimited lines
                softWrap: true, // Enable wrapping
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                ),
              ),
              Text(
                '${plan.nutPlan.numOfWeeks.toString()} ${FFLocalizations.of(context).getText('weeks' /* Weeks */)}',
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            FlutterFlowIconButton(
              borderRadius: ResponsiveUtils.width(context, 8.0),
              buttonSize: ResponsiveUtils.width(context, 40.0),
              fillColor: FlutterFlowTheme.of(context).primary,
              icon: Icon(
                Icons.edit_outlined,
                color: FlutterFlowTheme.of(context).info,
                size: ResponsiveUtils.iconSize(context, 24.0),
              ),
              onPressed: onEdit,
            ),
            SizedBox(width: ResponsiveUtils.width(context, 8)),
            FlutterFlowIconButton(
              borderRadius: ResponsiveUtils.width(context, 8.0),
              buttonSize: ResponsiveUtils.width(context, 40.0),
              fillColor: FlutterFlowTheme.of(context).error,
              icon: Icon(
                Icons.delete_sharp,
                color: FlutterFlowTheme.of(context).info,
                size: ResponsiveUtils.iconSize(context, 24.0),
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
          width: ResponsiveUtils.width(context, 60.0),
          height: ResponsiveUtils.height(context, 60.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).accent1,
            borderRadius:
                BorderRadius.circular(ResponsiveUtils.width(context, 30.0)),
          ),
          child: Icon(
            Icons.restaurant_menu,
            color: FlutterFlowTheme.of(context).primary,
            size: ResponsiveUtils.iconSize(context, 30.0),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${plan.nutPlan.meals.length.toString()} ${FFLocalizations.of(context).getText('meals' /* Meals */)}',
                style: AppStyles.textCairo(context,
                    fontSize: ResponsiveUtils.fontSize(context, 14)),
              ),
              Text(
                plan.nutPlan.nots,
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 12),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
        ),
      ].divide(SizedBox(width: ResponsiveUtils.width(context, 12.0))),
    );
  }

  FFButtonWidget _buildViewDetailsButton(BuildContext context) {
    return FFButtonWidget(
      onPressed: onViewDetails,
      text: FFLocalizations.of(context).getText('f0lulsew' /* View Details */),
      options: FFButtonOptions(
        width: MediaQuery.sizeOf(context).width,
        height: ResponsiveUtils.height(context, 40.0),
        padding: const EdgeInsets.all(0.0),
        iconPadding: const EdgeInsets.all(0.0),
        color: FlutterFlowTheme.of(context).primary,
        textStyle: AppStyles.textCairo(
          context,
          fontSize: ResponsiveUtils.fontSize(context, 14),
          color: FlutterFlowTheme.of(context).info,
        ),
        elevation: 0.0,
        borderRadius:
            BorderRadius.circular(ResponsiveUtils.width(context, 20.0)),
      ),
    );
  }
}
