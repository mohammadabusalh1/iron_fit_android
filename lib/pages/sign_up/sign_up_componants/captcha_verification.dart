import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/componants/captcha_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class CaptchaVerification extends StatelessWidget {
  final bool isVerified;
  final Function(bool) onVerificationChanged;

  const CaptchaVerification({
    super.key,
    required this.isVerified,
    required this.onVerificationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Create button options outside of the button to avoid rebuilding
    final buttonOptions = FFButtonOptions(
      width: double.infinity,
      height: 45.0,
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
      color: isVerified
          ? theme.success.withValues(alpha: 0.2)
          : theme.secondaryBackground,
      textStyle: AppStyles.textCairo(
        context,
        fontWeight: FontWeight.w600,
        color: isVerified ? theme.success : theme.primaryText,
      ),
      elevation: 0.0,
      borderSide: BorderSide(
        color:
            isVerified ? theme.success.withValues(alpha: 0.5) : theme.alternate,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );

    return FFButtonWidget(
      onPressed: () async {
        final isVerified =
            await CaptchaWidget.showCaptchaDialog(context).then((value) {
          return value;
        });
        onVerificationChanged(isVerified);
        if (context.mounted) {
          Future.delayed(const Duration(milliseconds: 300), () {
            FocusScope.of(context).unfocus();
          });
        }
      },
      text: isVerified
          ? FFLocalizations.of(context)
              .getText('verificationSuccessful' /* Verification successful */)
          : FFLocalizations.of(context)
              .getText('verifyHumanity' /* Verify you are human */),
      options: buttonOptions,
      icon: Icon(
        isVerified ? Icons.check_circle : Icons.security,
        color: isVerified ? theme.success : theme.primary,
        size: 20,
      ),
    );
  }
}
