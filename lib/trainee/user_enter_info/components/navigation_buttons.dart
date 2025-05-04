import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class NavigationButtons extends StatelessWidget {
  final int currentStep;
  final bool isLastStep;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NavigationButtons({
    super.key,
    required this.currentStep,
    required this.isLastStep,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.padding(context, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: ResponsiveUtils.width(context, 8.0)),
                child: FFButtonWidget(
                  onPressed: onPrevious,
                  text: FFLocalizations.of(context)
                      .getText('previous_step' /* Previous */),
                  options: FFButtonOptions(
                    height: ResponsiveUtils.height(context, 50.0),
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          SizedBox(width: ResponsiveUtils.width(context, 8.0)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: currentStep > 0 ? ResponsiveUtils.width(context, 8.0) : 0),
              child: FFButtonWidget(
                onPressed: onNext,
                text: isLastStep
                    ? FFLocalizations.of(context).getText('finish' /* Finish */)
                    : FFLocalizations.of(context)
                        .getText('next_step' /* Next */),
                options: FFButtonOptions(
                  height: ResponsiveUtils.height(context, 50.0),
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    color: FlutterFlowTheme.of(context).black,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 2.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
