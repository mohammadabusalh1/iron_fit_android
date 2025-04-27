import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // You can adjust these factors based on your design
    final titleFontSize = screenWidth * 0.09; // roughly 28 on 400px width
    final subtitleFontSize = screenWidth * 0.045; // roughly 16 on 400px width

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          FFLocalizations.of(context).getText('signUp'),
          style: AppStyles.textCairo(
            context,
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: theme.primaryText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          FFLocalizations.of(context).getText('l540r2yi'),
          textAlign: TextAlign.center,
          style: AppStyles.textCairo(
            context,
            fontSize: subtitleFontSize,
            color: theme.secondaryText,
          ),
        ),
      ],
    );
  }
}
