import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlansErrorWidget extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;

  const PlansErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final localizations = FFLocalizations.of(context);

    const animDuration = Duration(milliseconds: 300);
    const scaleDuration = Duration(milliseconds: 400);

    final errorMessage = error?.toString() ?? localizations.getText('2184r6dy');

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildErrorIcon(theme),
              const SizedBox(height: 24),
              Text(
                localizations.getText('defaultErrorMessage'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                style: AppStyles.textCairo(
                  context,
                  fontSize: 16,
                  color: theme.secondaryText,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              _buildRetryButton(context, theme, localizations),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: animDuration).scale(
          duration: scaleDuration,
          curve: Curves.easeOutBack,
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
        );
  }

  Widget _buildErrorIcon(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.error.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.error_outline_rounded,
        color: theme.error,
        size: 48,
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context, FlutterFlowTheme theme,
      FFLocalizations localizations) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: Text(
          localizations.getText('2ic7dbdd'),
          style: AppStyles.textCairo(
            context,
            fontSize: 16,
            color: theme.info,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primary,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
