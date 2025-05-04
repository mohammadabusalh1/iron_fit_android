import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class SubmitButtonSection extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onPressed;

  const SubmitButtonSection({
    super.key,
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.height(context, 24.0)),
      child: FFButtonWidget(
        onPressed: onPressed,
        text: isEditing
            ? FFLocalizations.of(context)
                .getText('updatePlan' /* Update Plan */)
            : FFLocalizations.of(context).getText('z0lxpu8b' /* Create Plan */),
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: ResponsiveUtils.height(context, 50.0),
          padding: EdgeInsets.zero,
          iconPadding: EdgeInsets.zero,
          color: FlutterFlowTheme.of(context).primary,
          textStyle: AppStyles.textCairo(
            context,
            color: FlutterFlowTheme.of(context).info,
            fontSize: ResponsiveUtils.fontSize(context, 16),
            fontWeight: FontWeight.bold,
          ),
          elevation: 0.0,
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
