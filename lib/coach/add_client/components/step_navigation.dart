import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/internationalization.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FFButtonWidget(
                  onPressed: onPrevious,
                  text: FFLocalizations.of(context).getText('previous_step'),
                  options: FFButtonOptions(
                    height: 50.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: AppStyles.textCairo(
                      context,
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
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
          const SizedBox(width: 8.0),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: currentStep > 0 ? 8.0 : 0),
              child: FFButtonWidget(
                onPressed: onNext,
                text: currentStep == totalSteps - 1
                    ? FFLocalizations.of(context).getText('finish')
                    : FFLocalizations.of(context).getText('next_step'),
                options: FFButtonOptions(
                  height: 50.0,
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).info,
                    fontWeight: FontWeight.bold,
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
