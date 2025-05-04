import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/utils/responsive_utils.dart';

class HeaderSection extends StatelessWidget {
  final bool isEditMode;

  const HeaderSection({
    super.key,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode
                  ? FFLocalizations.of(context).getText('uh8xi482')
                  : FFLocalizations.of(context)
                      .getText('drkdjo18' /* Create Plan */),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              isEditMode
                  ? FFLocalizations.of(context).getText('49kqh6e5')
                  : FFLocalizations.of(context)
                      .getText('h5uiph9g' /* Design a new training program */),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 16),
                color: const Color(0xFFE0E0E0),
              ),
            ),
          ],
        ),
        FlutterFlowIconButton(
          borderRadius: 8.0,
          buttonSize: ResponsiveUtils.width(context, 40.0),
          fillColor: const Color(0x33FFFFFF),
          icon: Icon(
            Icons.close,
            color: FlutterFlowTheme.of(context).info,
            size: ResponsiveUtils.iconSize(context, 24.0),
          ),
          onPressed: () async {
            context.pushNamed('CoachExercisesPlans');
          },
        ),
      ],
    );
  }
}
