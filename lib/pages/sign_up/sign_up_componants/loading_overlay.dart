import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final bool isSuccess;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    final theme = FlutterFlowTheme.of(context);

    // Define box decoration once
    final boxDecoration = BoxDecoration(
      color: theme.secondaryBackground,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000), // Colors.black.withValues(alpha: 0.1)
          spreadRadius: 1,
          blurRadius: 10,
        ),
      ],
    );

    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: boxDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSuccess) ...[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/success.json',
                      animate: true,
                      repeat: false,
                      width: 80,
                      height: 80,
                    ),
                    Lottie.asset(
                      'assets/lottie/cta.json',
                      animate: true,
                      repeat: false,
                      width: 120,
                      height: 120,
                    ),
                  ],
                ),
              ] else ...[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  FFLocalizations.of(context).getText('pleaseWait'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
