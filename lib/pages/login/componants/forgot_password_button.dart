import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: FlutterFlowTheme.of(context).primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          FFLocalizations.of(context)
              .getText('uym5vj9y' /* Forgot Password? */),
          style: AppStyles.textCairo(
            context,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      ),
    );
  }
}
