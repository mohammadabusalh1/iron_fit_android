import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class SignInButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const SignInButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: isEnabled ? onPressed : null,
      text: FFLocalizations.of(context).getText('by7fphqy' /* Sign In */),
      options: FFButtonOptions(
        width: double.infinity,
        height: ResponsiveUtils.height(context, 50),
        padding: ResponsiveUtils.padding(context, vertical: 0, horizontal: 24),
        iconPadding: ResponsiveUtils.padding(context, horizontal: 0),
        color: isEnabled
            ? FlutterFlowTheme.of(context).primary
            : FlutterFlowTheme.of(context).primaryBackground,
        textStyle: AppStyles.textCairo(
          context,
          fontWeight: FontWeight.w600,
          fontSize: ResponsiveUtils.fontSize(context, 16),
          color: isEnabled
              ? FlutterFlowTheme.of(context).primaryBackground
              : FlutterFlowTheme.of(context).secondaryText,
        ),
        elevation: isEnabled ? 3 : 0,
        borderSide: BorderSide(
          color: isEnabled
              ? Colors.transparent
              : FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
        disabledColor: FlutterFlowTheme.of(context).secondaryBackground,
        disabledTextColor: FlutterFlowTheme.of(context).secondaryText,
      ),
    );
  }
}
