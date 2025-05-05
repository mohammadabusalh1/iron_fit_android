import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/internationalization.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/componants/Styles.dart';

class StepNavigation extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const StepNavigation({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          ResponsiveUtils.padding(context, vertical: 24.0, horizontal: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0)
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.only(right: ResponsiveUtils.width(context, 8.0)),
                child: FFButtonWidget(
                  onPressed: onPrevious,
                  text: FFLocalizations.of(context).getText('previous_step'),
                  options: FFButtonOptions(
                    height: ResponsiveUtils.height(context, 50.0),
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: AppStyles.textCairo(
                      context,
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          SizedBox(width: ResponsiveUtils.width(context, 8.0)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: currentStep > 0
                      ? ResponsiveUtils.width(context, 8.0)
                      : 0),
              child: FFButtonWidget(
                onPressed: onNext,
                text: currentStep == totalSteps - 1
                    ? FFLocalizations.of(context).getText('finish')
                    : FFLocalizations.of(context).getText('next_step'),
                options: FFButtonOptions(
                  height: ResponsiveUtils.height(context, 50.0),
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).info,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                  ),
                  elevation: 2.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
