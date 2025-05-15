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
  final bool isLoading;

  const SocialLoginButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
    this.isLoading = false,
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
            text: FFLocalizations.of(context)
                .getText('m4fuhw1y' /* Continue with Google */),
            onPressed: isLoading ? null : onGooglePressed,
            isDisabled: isLoading,
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
              text: FFLocalizations.of(context)
                  .getText('continueWithApple' /* Continue with Apple */),
              onPressed: isLoading ? null : onApplePressed,
              isDisabled: isLoading,
            ),
          ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;

  const _SocialButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
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
        onTap: isDisabled ? null : onPressed,
        borderRadius:
            BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        child: Container(
          width: double.infinity,
          height: ResponsiveUtils.height(context, 55),
          decoration: BoxDecoration(
            color: isDisabled
                ? FlutterFlowTheme.of(context).alternate.withOpacity(0.2)
                : FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius:
                BorderRadius.circular(ResponsiveUtils.width(context, 16)),
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
                  color: isDisabled
                      ? FlutterFlowTheme.of(context).secondaryText
                      : FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
