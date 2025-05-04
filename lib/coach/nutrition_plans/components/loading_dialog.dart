import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

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
        padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: ResponsiveUtils.height(context, 50),
              width: ResponsiveUtils.width(context, 50),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 16)),
            Text(
              message,
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 16),
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
