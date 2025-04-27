import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({
    super.key,
    required this.message,
  });

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) => ErrorDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: FlutterFlowTheme.of(context).error,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            FFLocalizations.of(context).getText('error' /* Error */),
            style: AppStyles.textCairo(
              context,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).error,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppStyles.textCairo(
              context,
              fontSize: 16,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: FFButtonWidget(
            onPressed: () => Navigator.of(context).pop(),
            text: FFLocalizations.of(context).getText('ok' /* OK */),
            options: FFButtonOptions(
              height: 50,
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: AppStyles.textCairo(
                context,
                fontSize: 16,
                color: FlutterFlowTheme.of(context).info,
                fontWeight: FontWeight.bold,
              ),
              elevation: 2,
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
