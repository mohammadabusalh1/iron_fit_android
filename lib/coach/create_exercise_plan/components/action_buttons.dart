import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/responsive_utils.dart';

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
            height: ResponsiveUtils.height(context, 50.0),
            padding: ResponsiveUtils.padding(context, horizontal: 0.0, vertical: 0.0),
            iconPadding: ResponsiveUtils.padding(context, horizontal: 0.0, vertical: 0.0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 16),
              color: FlutterFlowTheme.of(context).info,
            ),
            elevation: 3.0,
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        if (!isEditMode && onSaveAsDraft != null)
          Padding(
            padding: EdgeInsets.only(bottom: ResponsiveUtils.height(context, 12.0)),
            child: FFButtonWidget(
              onPressed: onSaveAsDraft,
              text: FFLocalizations.of(context)
                  .getText('wowhr087' /* Save as Draft */),
              options: FFButtonOptions(
                width: MediaQuery.sizeOf(context).width,
                height: ResponsiveUtils.height(context, 50.0),
                padding: ResponsiveUtils.padding(context, horizontal: 0.0, vertical: 0.0),
                iconPadding: ResponsiveUtils.padding(context, horizontal: 0.0, vertical: 0.0),
                color: const Color(0x00FFFFFF),
                textStyle: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
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
      ].divide(SizedBox(height: ResponsiveUtils.height(context, 12.0))),
    );
  }
}
