import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class StepIndicator extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  State<StepIndicator> createState() => _StepIndicatorState();
}

class _StepIndicatorState extends State<StepIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _updateProgressAnimation();
  }

  @override
  void didUpdateWidget(StepIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _updateProgressAnimation();
    }
  }

  void _updateProgressAnimation() {
    final beginValue = widget.currentStep / (widget.totalSteps - 1);
    _progressAnimation = Tween<double>(
      begin: beginValue,
      end: widget.currentStep / (widget.totalSteps - 1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.padding(context, vertical: 16.0),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                children: [
                  // Progress line
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: ResponsiveUtils.height(context, 3),
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                  ),
                  // Completed progress line
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          height: ResponsiveUtils.height(context, 3),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Step dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      widget.totalSteps,
                      (index) => _buildStepIndicator(index, context),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: ResponsiveUtils.height(context, 12)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              widget.stepTitles[widget.currentStep],
              key: ValueKey<String>(widget.stepTitles[widget.currentStep]),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 18),
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index, BuildContext context) {
    final isActive = index == widget.currentStep;
    final isCompleted = index < widget.currentStep;

    return Container(
      width: ResponsiveUtils.width(context, 32),
      height: ResponsiveUtils.width(context, 32),
      decoration: BoxDecoration(
        color: isCompleted
            ? FlutterFlowTheme.of(context).primary
            : isActive
                ? FlutterFlowTheme.of(context).primaryBackground
                : FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive || isCompleted
              ? FlutterFlowTheme.of(context).primary
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                  blurRadius: 6,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? Icon(
                Icons.check,
                size: ResponsiveUtils.iconSize(context, 16),
                color: FlutterFlowTheme.of(context).primaryBackground,
              )
            : Text(
                '${index + 1}',
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
      ),
    );
  }
}
