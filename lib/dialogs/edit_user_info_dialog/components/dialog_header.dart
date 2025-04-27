import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.textCairo(
            context,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        Hero(
          tag: 'closeButton',
          child: FlutterFlowIconButton(
            borderColor:
                FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.2),
            borderRadius: 12.0,
            borderWidth: 1,
            buttonSize: 40.0,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            icon: Icon(
              Icons.close_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
            onPressed: onClose,
          ),
        ),
      ],
    );
  }
}
