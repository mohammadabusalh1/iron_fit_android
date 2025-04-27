import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/componants/Styles.dart';

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({
    super.key,
    required this.message,
  });

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppStyles.textCairo(
                context,
                fontSize: 16,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
