import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  const SignInButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                  spreadRadius: -4,
                )
              ]
            : [],
      ),
      child: FFButtonWidget(
        key: const Key('login_button'),
        onPressed: isEnabled ? onPressed : null,
        text: FFLocalizations.of(context).getText('by7fphqy' /* Sign In */),
        options: FFButtonOptions(
          width: double.infinity,
          height: 55.0,
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: isEnabled
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).primary.withValues(alpha: 0.5),
          textStyle: AppStyles.textCairo(
            context,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          elevation: 0.0,
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
          disabledColor: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
          disabledTextColor:
              FlutterFlowTheme.of(context).primaryBackground.withOpacity(0.5),
        ),
      ),
    );
  }
}
