import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';

class StepHeader extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onClose;
  final int currentStep;
  final int totalSteps;

  const StepHeader({
    super.key,
    required this.title,
    required this.description,
    required this.onClose,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${FFLocalizations.of(context).getText('step')} ${currentStep + 1} / $totalSteps',
          style: AppStyles.textCairo(
            context,
            fontSize: 16,
            color: FlutterFlowTheme.of(context).primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: Icon(
            Icons.close_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          splashRadius: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
        ),
      ],
    );
  }
}
