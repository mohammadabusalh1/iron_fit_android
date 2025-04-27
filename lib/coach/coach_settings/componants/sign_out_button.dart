import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SignOutButton extends StatelessWidget {
  final Function() onPressed;

  const SignOutButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: onPressed,
      text: FFLocalizations.of(context).getText('rht8hzyz'),
      options: FFButtonOptions(
        width: MediaQuery.sizeOf(context).width,
        height: 50.0,
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: FlutterFlowTheme.of(context).error,
        textStyle: AppStyles.textCairo(
          context,
          fontWeight: FontWeight.w600,
          color: FlutterFlowTheme.of(context).info,
          fontSize: 16,
        ),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
