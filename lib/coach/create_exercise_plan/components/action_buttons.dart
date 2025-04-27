import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class ActionButtons extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onCreateOrUpdate;
  final VoidCallback? onSaveAsDraft;

  const ActionButtons({
    super.key,
    required this.isEditMode,
    required this.onCreateOrUpdate,
    this.onSaveAsDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FFButtonWidget(
          onPressed: onCreateOrUpdate,
          text: isEditMode
              ? FFLocalizations.of(context).getText('uh8xi482') // Update Plan
              : FFLocalizations.of(context)
                  .getText('bj0yxoi0' /* Create Plan */),
          options: FFButtonOptions(
            width: MediaQuery.sizeOf(context).width,
            height: 50.0,
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding:
                const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: AppStyles.textCairo(
              context,
              fontSize: 16,
              color: FlutterFlowTheme.of(context).info,
            ),
            elevation: 3.0,
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        if (!isEditMode && onSaveAsDraft != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: FFButtonWidget(
              onPressed: onSaveAsDraft,
              text: FFLocalizations.of(context)
                  .getText('wowhr087' /* Save as Draft */),
              options: FFButtonOptions(
                width: MediaQuery.sizeOf(context).width,
                height: 50.0,
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: const Color(0x00FFFFFF),
                textStyle: AppStyles.textCairo(
                  context,
                  fontSize: 16,
                  color: FlutterFlowTheme.of(context).info,
                ),
                elevation: 0.0,
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).info,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
      ].divide(const SizedBox(height: 12.0)),
    );
  }
}
