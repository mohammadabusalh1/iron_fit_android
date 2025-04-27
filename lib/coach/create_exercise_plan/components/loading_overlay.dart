import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
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
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      color: FlutterFlowTheme.of(context).black.withAlpha(150),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color:
                    FlutterFlowTheme.of(context).black.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
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
                      repeat: true,
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
                Lottie.asset(
                  'assets/lottie/create_plan.json',
                  animate: true,
                  repeat: true,
                  width: 100,
                  height: 100,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
