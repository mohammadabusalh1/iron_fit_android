import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CreateAccountButton extends StatelessWidget {
  final bool isLoading;
  final bool isCaptchaVerified;
  final VoidCallback onPressed;
  final Animation<double> scaleAnimation;

  const CreateAccountButton({
    super.key,
    required this.isLoading,
    required this.isCaptchaVerified,
    required this.onPressed,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isDisabled = isLoading || !isCaptchaVerified;

    return ScaleTransition(
      scale: scaleAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, isLoading ? -2 : 0, 0),
        child: Container(
          width: double.infinity,
          height: 56.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDisabled
                  ? [theme.primary.withAlpha(150), theme.primary.withAlpha(120)]
                  : [theme.primary, theme.primary.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: isDisabled || isLoading
                ? []
                : [
                    BoxShadow(
                      color: theme.primary.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: isDisabled
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      onPressed();
                    },
              splashColor: theme.primaryBackground.withOpacity(0.1),
              highlightColor: Colors.transparent,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.primaryBackground,
                            ),
                          ),
                        )
                      : Text(
                          FFLocalizations.of(context).getText('k4gozom7'),
                          key: const ValueKey('create_account_text'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.primaryBackground,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
