import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'exercise_card.dart';

class AppMessageCard extends StatelessWidget {
  const AppMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.card_giftcard_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    FFLocalizations.of(context).getText('mc7rofba'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 14,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share_rounded, size: 20),
                label: Text(
                  FFLocalizations.of(context)
                      .getText(LocalizationKeys.inviteFriends),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 14,
                    color: FlutterFlowTheme.of(context).info,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Implement share functionality
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
