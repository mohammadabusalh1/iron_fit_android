import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
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
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: ResponsiveUtils.padding(context, vertical: 8.0),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: ResponsiveUtils.padding(context, horizontal: 8.0, vertical: 4.0),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            FFLocalizations.of(context).getText('forgotPassword' /* Forgot Password? */),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 13),
              fontWeight: FontWeight.w500,
              color: FlutterFlowTheme.of(context).primary,
            ),
          ),
        ),
      ),
    );
  }
}
