import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:logging/logging.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/componants/Styles.dart';
import '/utils/responsive_utils.dart';

class AccountSettings extends StatelessWidget {
  static final _logger = Logger('AccountSettings');

  final Function(CoachRecord) onDeleteAccount;

  const AccountSettings({
    super.key,
    required this.onDeleteAccount,
  });

  // Text styles helper
  TextStyle _getTextStyle(
    BuildContext context, {
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return AppStyles.textCairo(
      context,
      color: color ?? FlutterFlowTheme.of(context).primaryText,
      fontSize: ResponsiveUtils.fontSize(context, fontSize ?? 14),
      fontWeight: fontWeight ?? FontWeight.normal,
      fontStyle: fontStyle ?? FontStyle.normal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.edit_outlined,
        'title': 'k0mwnwkl',
        'onTap': () async {
          context.pushNamed(
            'CoachEnterInfo',
            queryParameters: {
              'isEditing': serializeParam(
                true,
                ParamType.bool,
              ),
            },
          );
        },
      },
      {
        'icon': Icons.password_outlined,
        'title': 'change_password',
        'onTap': () async {
          if (currentUserEmail.isNotEmpty) {
            // Capture strings before async operation
            final successMessage =
                FFLocalizations.of(context).getText('password_reset_sent');
            final errorMessage =
                FFLocalizations.of(context).getText('password_reset_failed');

            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                );
              },
            );

            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: currentUserEmail,
              );

              // Close loading dialog
              if (context.mounted) Navigator.of(context).pop();

              // Check if context is still valid
              if (context.mounted) {
                showSuccessDialog(successMessage, context);
              }
            } catch (e) {
              // Close loading dialog
              if (context.mounted) Navigator.of(context).pop();

              _logger.warning('Error sending password reset email: $e');
              if (context.mounted) {
                showErrorDialog(errorMessage, context);
              }
            }
          }
        },
      },
      {
        'icon': Icons.translate_sharp,
        'title': 'change_language',
        'onTap': () async {
          if (FFLocalizations.of(context).languageCode == 'en') {
            setAppLanguage(context, 'ar');
          } else {
            setAppLanguage(context, 'en');
          }
        },
      },
      {
        'icon': Icons.help_outline_rounded,
        'title': 'help_center',
        'onTap': () async {
          context.pushNamed('Contact');
        },
      },
      {
        'icon': Icons.delete_forever_outlined,
        'title': 'delete_account',
        'onTap': () => _showDeleteAccountDialog(context),
      },
    ];

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: FlutterFlowTheme.of(context).primary,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
              SizedBox(width: ResponsiveUtils.width(context, 12)),
              Text(
                FFLocalizations.of(context)
                    .getText('ux9ea1rv' /* Account Settings */),
                style: _getTextStyle(
                  context,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).info.withOpacity(0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 16)),
          ...menuItems.map((item) => _buildSettingsItem(
                context,
                icon: item['icon'] as IconData,
                titleKey: item['title'] as String,
                onTap: item['onTap'] as Function(),
              )),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String titleKey,
    required Function() onTap,
  }) {
    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveUtils.height(context, 16)),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius:
              BorderRadius.circular(ResponsiveUtils.width(context, 12)),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary.withAlpha(15),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(ResponsiveUtils.width(context, 12)),
          child: Padding(
            padding: ResponsiveUtils.padding(
              context,
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.all(ResponsiveUtils.width(context, 8)),
                      decoration: BoxDecoration(
                        color:
                            FlutterFlowTheme.of(context).primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(
                            ResponsiveUtils.width(context, 8)),
                      ),
                      child: Icon(
                        icon,
                        color: FlutterFlowTheme.of(context).primary,
                        size: ResponsiveUtils.iconSize(context, 20),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 12)),
                    Text(
                      FFLocalizations.of(context).getText(titleKey),
                      style: _getTextStyle(
                        context,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: ResponsiveUtils.iconSize(context, 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveUtils.width(context, 16)),
          ),
          child: Container(
            padding:
                ResponsiveUtils.padding(context, horizontal: 24, vertical: 24),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius:
                  BorderRadius.circular(ResponsiveUtils.width(context, 16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: FlutterFlowTheme.of(context).error,
                  size: ResponsiveUtils.iconSize(context, 48),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                Text(
                  FFLocalizations.of(context).getText('delete_account_title'),
                  style: _getTextStyle(
                    context,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 8)),
                Text(
                  FFLocalizations.of(context).getText('delete_account_confirm'),
                  textAlign: TextAlign.center,
                  style: _getTextStyle(
                    context,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          FFLocalizations.of(context).getText('cancel'),
                          style: _getTextStyle(
                            context,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          onDeleteAccount(currentCoachDocument!);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: FlutterFlowTheme.of(context).error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          FFLocalizations.of(context).getText('delete'),
                          style: _getTextStyle(
                            context,
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
