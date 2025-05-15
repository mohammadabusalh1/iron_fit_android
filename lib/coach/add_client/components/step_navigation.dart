import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/internationalization.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class StepNavigation extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool hasErrors;

  const StepNavigation({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onPrevious,
    this.hasErrors = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress
    // final progress = (currentStep + 1) / totalSteps;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: ResponsiveUtils.width(context, 24),
      ),
      child: Column(
        children: [
          // Progress indicator
          // Container(
          //   width: double.infinity,
          //   height: ResponsiveUtils.height(context, 6),
          //   decoration: BoxDecoration(
          //     color: FlutterFlowTheme.of(context).primaryBackground,
          //     borderRadius: BorderRadius.circular(
          //       ResponsiveUtils.height(context, 3),
          //     ),
          //   ),
          //   child: Stack(
          //     children: [
          //       Container(
          //         width: MediaQuery.of(context).size.width * progress,
          //         decoration: BoxDecoration(
          //           color: hasErrors
          //               ? FlutterFlowTheme.of(context).error
          //               : FlutterFlowTheme.of(context).primary,
          //           borderRadius: BorderRadius.circular(
          //             ResponsiveUtils.height(context, 3),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: ResponsiveUtils.height(context, 16)),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              if (currentStep > 0)
                InkWell(
                  onTap: onPrevious,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.width(context, 24),
                      vertical: ResponsiveUtils.height(context, 12),
                    ),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.height(context, 8),
                      ),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: ResponsiveUtils.fontSize(context, 16),
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        SizedBox(width: ResponsiveUtils.width(context, 8)),
                        Text(
                          FFLocalizations.of(context).getText('go_back'),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .copyWith(
                                color: FlutterFlowTheme.of(context).primary,
                                fontWeight: FontWeight.w500,
                                fontSize: ResponsiveUtils.fontSize(context, 14),
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const SizedBox(),

              // Next/Submit button
              InkWell(
                onTap: onNext,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.width(context, 24),
                    vertical: ResponsiveUtils.height(context, 12),
                  ),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.height(context, 8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        currentStep == totalSteps - 1
                            ? FFLocalizations.of(context).getText('submit')
                            : FFLocalizations.of(context).getText('next'),
                        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              color: FlutterFlowTheme.of(context).info,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveUtils.fontSize(context, 14),
                            ),
                      ),
                      if (currentStep < totalSteps - 1) ...[
                        SizedBox(width: ResponsiveUtils.width(context, 8)),
                        Icon(
                          Icons.arrow_forward,
                          size: ResponsiveUtils.fontSize(context, 16),
                          color: FlutterFlowTheme.of(context).info,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveUtils.height(context, 16)),

          // Step counter text
          // Container(
          //   margin: EdgeInsets.only(top: ResponsiveUtils.height(context, 16)),
          //   child: Text(
          //     '${currentStep + 1}/$totalSteps',
          //     style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
          //           color: FlutterFlowTheme.of(context).secondaryText,
          //           fontSize: ResponsiveUtils.fontSize(context, 12),
          //         ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
