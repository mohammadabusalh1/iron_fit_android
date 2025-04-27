import 'package:flutter/material.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'theme_cache.dart';

class ProfileTabs extends StatelessWidget {
  final TabController tabController;
  final ThemeCache themeCache;
  final Function(int) onTabTap;

  const ProfileTabs({
    super.key,
    required this.tabController,
    required this.themeCache,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: themeCache.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: TabBar(
            onTap: onTabTap,
            controller: tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: themeCache.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: themeCache.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: themeCache.infoColor,
            unselectedLabelColor: themeCache.secondaryTextColor,
            labelStyle: AppStyles.textCairo(
              context,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppStyles.textCairo(
              context,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                return states.contains(WidgetState.focused)
                    ? null
                    : Colors.transparent;
              },
            ),
            splashFactory: NoSplash.splashFactory,
            tabs: [
              _buildTab(
                  context, 0, Icons.emoji_events_outlined, 'achievements'),
              _buildTab(context, 1, Icons.bar_chart_rounded, 'stats'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
      BuildContext context, int index, IconData icon, String textKey) {
    final isSelected = tabController.index == index;
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected
                ? themeCache.infoColor
                : themeCache.secondaryTextColor,
          ),
          FFLocalizations.of(context).languageCode == 'en'
              ? const SizedBox(width: 4)
              : const SizedBox(width: 8),
          Text(
            FFLocalizations.of(context).getText(textKey),
            style: AppStyles.textCairo(
              context,
              fontSize:
                  FFLocalizations.of(context).languageCode == 'en' ? 14 : 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? themeCache.infoColor
                  : themeCache.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
