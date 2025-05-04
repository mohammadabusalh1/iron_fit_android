import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import '/componants/Styles.dart';
import 'setting_card.dart';
import 'language_selector.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.trainee,
    required this.onEditProfile,
    required this.onDeleteAccount,
    required this.currentUserEmail,
  });

  final TraineeRecord trainee;
  final VoidCallback onEditProfile;
  final VoidCallback onDeleteAccount;
  final String currentUserEmail;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 0.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value * ResponsiveUtils.height(context, 50)),
          child: Opacity(
            opacity: 1 - value,
            child: child,
          ),
        );
      },
      child: _buildSettingsContent(context),
    );
  }

  // Extract widget creation to minimize rebuilds during animation
  Widget _buildSettingsContent(BuildContext context) {
    // Using a method to create responsive SizedBox
    final sizedBox20 = SizedBox(height: ResponsiveUtils.height(context, 20));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: ResponsiveUtils.width(context, 4),
            bottom: ResponsiveUtils.height(context, 16),
          ),
          child: Text(
            FFLocalizations.of(context).getText('account_settings'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.7),
            ),
          ),
        ),
        SettingCard(
          title: FFLocalizations.of(context).getText('edit_profile'),
          subtitle:
              FFLocalizations.of(context).getText('edit_profile_subtitle'),
          icon: Icons.person_outline,
          onTap: onEditProfile,
          color: Colors.blue,
        ),
        SettingCard(
          title: FFLocalizations.of(context).getText('change_password'),
          subtitle:
              FFLocalizations.of(context).getText('change_password_subtitle'),
          icon: Icons.lock_outline,
          onTap: () async {
            if (currentUserEmail.isNotEmpty) {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: currentUserEmail,
                );
                if (context.mounted) {
                  showSuccessDialog(
                      FFLocalizations.of(context)
                          .getText('password_reset_sent'),
                      context);
                }
              } catch (e) {
                if (context.mounted) {
                  showErrorDialog(
                      FFLocalizations.of(context)
                          .getText('password_reset_failed'),
                      context);
                }
              }
            }
          },
          color: FlutterFlowTheme.of(context).tertiary,
        ),
        sizedBox20,
        Padding(
          padding: EdgeInsets.only(
            left: ResponsiveUtils.width(context, 4),
            bottom: ResponsiveUtils.height(context, 16),
          ),
          child: Text(
            FFLocalizations.of(context).getText('app_settings'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.7),
            ),
          ),
        ),
        const LanguageSelector(),
        sizedBox20,
        SettingCard(
          title: FFLocalizations.of(context).getText('help_center'),
          subtitle: FFLocalizations.of(context).getText('help_center_subtitle'),
          icon: Icons.help_outline_rounded,
          onTap: () => context.pushNamed('Contact'),
          color: FlutterFlowTheme.of(context).success,
        ),
        sizedBox20,
        Padding(
          padding: EdgeInsets.only(
            left: ResponsiveUtils.width(context, 4),
            bottom: ResponsiveUtils.height(context, 16),
          ),
          child: Text(
            FFLocalizations.of(context).getText('danger_zone'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).error.withOpacity(0.8),
            ),
          ),
        ),
        SettingCard(
          title: FFLocalizations.of(context).getText('delete_account'),
          subtitle:
              FFLocalizations.of(context).getText('delete_account_warning'),
          icon: Icons.delete_forever_outlined,
          onTap: onDeleteAccount,
          color: FlutterFlowTheme.of(context).error,
          trailing: Container(
            padding: ResponsiveUtils.padding(
              context,
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 8)),
            ),
            child: Text(
              FFLocalizations.of(context).getText('danger'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 12),
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
