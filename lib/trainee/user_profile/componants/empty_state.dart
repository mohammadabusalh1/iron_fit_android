import 'package:flutter/material.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'theme_cache.dart';
import '/utils/responsive_utils.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  final String subtitleKey;
  final ThemeCache themeCache;

  const EmptyState({
    super.key,
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.themeCache,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.iconSize(context, 64),
            color: themeCache.secondaryTextColor.withValues(alpha: 0.5),
          ),
          SizedBox(height: ResponsiveUtils.height(context, 16)),
          Text(
            FFLocalizations.of(context).getText(titleKey),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 18),
              color: themeCache.secondaryTextColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.height(context, 8)),
          Text(
            FFLocalizations.of(context).getText(subtitleKey),
            textAlign: TextAlign.center,
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: themeCache.secondaryTextColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
