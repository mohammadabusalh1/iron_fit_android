import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:animate_do/animate_do.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;

  const SocialLoginButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 400),
          child: GoogleSignInButton(onPressed: onGooglePressed),
        ),
        if (Platform.isIOS || Platform.isMacOS)
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: AppleSignInButton(onPressed: onApplePressed),
            ),
          ),
      ],
    );
  }
}

// Extracted Google Sign In Button
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FFButtonWidget(
        onPressed: onPressed,
        text: FFLocalizations.of(context)
            .getText('m4fuhw1y' /* Continue with Google */),
        icon: Image.asset(
          'assets/images/google-logo.png',
          width: 24,
          height: 24,
        ),
        options: FFButtonOptions(
          width: double.infinity,
          height: 55.0,
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          iconPadding:
              const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).secondaryBackground,
          textStyle: AppStyles.textCairo(
            context,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          elevation: 0.0,
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate.withOpacity(0.6),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
          hoverColor: FlutterFlowTheme.of(context).primaryBackground,
        ),
      ),
    );
  }
}

// Extracted Apple Sign In Button
class AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppleSignInButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FFButtonWidget(
        onPressed: onPressed,
        text: FFLocalizations.of(context)
            .getText('continueWithApple' /* Continue with Apple */),
        icon: Icon(
          Icons.apple,
          size: 26,
          color: FlutterFlowTheme.of(context).primaryText,
        ),
        options: FFButtonOptions(
          width: double.infinity,
          height: 55.0,
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          iconPadding:
              const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).secondaryBackground,
          textStyle: AppStyles.textCairo(
            context,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          elevation: 0.0,
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate.withOpacity(0.6),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
          hoverColor: FlutterFlowTheme.of(context).primaryBackground,
        ),
      ),
    );
  }
}
