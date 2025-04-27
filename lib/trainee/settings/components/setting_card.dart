import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Hero(
        tag: 'setting_$title',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: color.withOpacity(0.1),
            highlightColor: color.withOpacity(0.05),
            child: Ink(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppStyles.textCairo(
                              context,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: AppStyles.textCairo(
                                context,
                                fontSize: 13,
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
                          size: 22,
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
