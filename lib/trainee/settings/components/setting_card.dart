import 'package:flutter/material.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.height(context, 16)),
      child: Hero(
        tag: 'setting_$title',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
            splashColor: color.withOpacity(0.1),
            highlightColor: color.withOpacity(0.05),
            child: Ink(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: ResponsiveUtils.padding(
                  context,
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Container(
                      width: ResponsiveUtils.width(context, 48),
                      height: ResponsiveUtils.height(context, 48),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 14)),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: ResponsiveUtils.iconSize(context, 22),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppStyles.textCairo(
                              context,
                              fontSize: ResponsiveUtils.fontSize(context, 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: ResponsiveUtils.height(context, 4)),
                            Text(
                              subtitle!,
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 13),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    trailing ??
                        Icon(
                          Icons.chevron_right_rounded,
                          color: FlutterFlowTheme.of(context)
                              .secondaryText
                              .withOpacity(0.5),
                          size: ResponsiveUtils.iconSize(context, 22),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
