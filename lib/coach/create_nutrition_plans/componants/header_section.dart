import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HeaderSection extends StatelessWidget {
  final bool isEditing;

  const HeaderSection({
    super.key,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing
                    ? FFLocalizations.of(context)
                        .getText('editNutritionPlan' /* Edit Nutrition Plan */)
                    : FFLocalizations.of(context)
                        .getText('i9vve0di' /* Create Nutrition Plan */),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 20,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed('NutritionPlans');
                },
                child: Icon(
                  Icons.close,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ),
            ],
          ),
          Text(
            isEditing
                ? FFLocalizations.of(context).getText(
                    'updateYourNutritionPlan' /* Update your nutrition plan */)
                : FFLocalizations.of(context)
                    .getText('h5t7ep68' /* Create Nutrition Plan */),
            style: AppStyles.textCairo(
              context,
              fontSize: 12,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ].divide(const SizedBox(height: 4)),
      ),
    );
  }
}
