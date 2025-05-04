import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/responsive_utils.dart';

class SubscriptionsHeader extends StatelessWidget {
  const SubscriptionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: ResponsiveUtils.iconSize(context, 24),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        SizedBox(width: ResponsiveUtils.width(context, 8)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FFLocalizations.of(context).getText(
                'chooseYourPlan' /* Choose Your Plan */,
              ),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              FFLocalizations.of(context).getText(
                'selectThePerfectSubscription' /* Select the perfect subscription... */,
              ),
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
