import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class SocialSignInButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;

  const SocialSignInButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildGoogleSignInButton(context),
        if (Platform.isIOS || Platform.isMacOS)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: _buildAppleSignInButton(context),
          ),
      ],
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).secondaryText.withAlpha(15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: FFButtonWidget(
        onPressed: onGooglePressed,
        text: FFLocalizations.of(context)
            .getText('9r44g6ni' /* Continue with Google */),
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset(
            'assets/images/google-logo.png',
            width: 24,
            height: 24,
          ),
        ),
        options: FFButtonOptions(
          width: double.infinity,
          height: 50.0,
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).secondaryBackground,
          textStyle: AppStyles.textCairo(
            context,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          elevation: 0.0,
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  Widget _buildAppleSignInButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).secondaryText.withAlpha(15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: FFButtonWidget(
        onPressed: onApplePressed,
        text: FFLocalizations.of(context)
            .getText('continueWithApple' /* Continue with Apple */),
        icon: Icon(
          Icons.apple,
          size: 24,
          color: FlutterFlowTheme.of(context).info,
        ),
        options: FFButtonOptions(
          width: double.infinity,
          height: 50.0,
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).secondaryBackground,
          textStyle: AppStyles.textCairo(
            context,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          elevation: 0.0,
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
