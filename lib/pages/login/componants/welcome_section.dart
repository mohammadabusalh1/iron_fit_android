import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:animate_do/animate_do.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App logo with bounce animation
        FadeInDown(
          duration: const Duration(milliseconds: 800),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/login.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Welcome text with slide animation
        FadeIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 300),
          child: Text(
            FFLocalizations.of(context).getText('5f1qv9wo'),
            style: AppStyles.textCairo(
              context,
              fontSize: 32, // Increased size
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ),

        const SizedBox(height: 4), // Increased spacing

        // Subtitle with fade animation
        FadeIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 500),
          child: Text(
            FFLocalizations.of(context).getText('l540r2yi'),
            textAlign: TextAlign.center,
            style: AppStyles.textCairo(
              context,
              fontSize: 16,
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.3, // Added letter spacing for better readability
            ),
          ),
        ),
      ],
    );
  }
}
