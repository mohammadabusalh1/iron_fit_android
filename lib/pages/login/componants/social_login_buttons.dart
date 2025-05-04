import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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
          child: _SocialButton(
            icon: Image.asset(
              'assets/images/google-logo.png',
              width: ResponsiveUtils.width(context, 24),
              height: ResponsiveUtils.height(context, 24),
            ),
            text: FFLocalizations.of(context).getText('m4fuhw1y' /* Continue with Google */),
            onPressed: onGooglePressed,
          ),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 12)),
        if (Platform.isIOS || Platform.isMacOS)
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: _SocialButton(
              icon: Icon(
                Icons.apple,
                size: ResponsiveUtils.iconSize(context, 26),
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              text: FFLocalizations.of(context).getText('continueWithApple' /* Continue with Apple */),
              onPressed: onApplePressed,
            ),
          ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: ResponsiveUtils.width(context, 10),
            offset: Offset(0, ResponsiveUtils.height(context, 4)),
          ),
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        child: Container(
          width: double.infinity,
          height: ResponsiveUtils.height(context, 55),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate.withOpacity(0.6),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(width: ResponsiveUtils.width(context, 12)),
              Text(
                text,
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 15),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
