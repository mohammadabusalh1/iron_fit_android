import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/navigation/navigation_service.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'user_nav_model.dart';
export 'user_nav_model.dart';

class UserNavWidget extends StatefulWidget {
  final int num;

  /// create navbar has: home, clients, plans, messages and analytics
  const UserNavWidget({super.key, required this.num});

  @override
  State<UserNavWidget> createState() => _UserNavWidgetState();
}

class _UserNavWidgetState extends State<UserNavWidget>
    with SingleTickerProviderStateMixin {
  late UserNavModel _model;
  late AnimationController _animationController;
  final NavigationService _navigationService = NavigationService();

  // Cache nav items to prevent rebuilds
  final Map<int, Widget> _navItemCache = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserNavModel());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.maybeDispose();
    super.dispose();
  }

  // Clear cache when dependencies change
  @override
  void didChangeDependencies() {
    _navItemCache.clear();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(UserNavWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.num != widget.num) {
      // Only clear affected items when selection changes
      _navItemCache.remove(oldWidget.num);
      _navItemCache.remove(widget.num);
    }
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
    bool isFontAwesome = false,
  }) {
    // Return cached item if available
    if (_navItemCache.containsKey(index)) {
      return _navItemCache[index]!;
    }

    final isSelected = widget.num == index;
    final secondaryTextColor = FlutterFlowTheme.of(context).secondaryText;
    final infoColor = FlutterFlowTheme.of(context).info;

    // Create and cache the nav item
    final navItem = Expanded(
      flex: 1,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          _animationController.forward(from: 0);
          onTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.width(context, 12)),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFFFFB800) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 1.0,
                  end: 1.1,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                )),
                child: isFontAwesome
                    ? FaIcon(
                        icon,
                        color: isSelected ? infoColor : secondaryTextColor,
                        size: ResponsiveUtils.iconSize(context, 20.0),
                      )
                    : Icon(
                        icon,
                        color: isSelected ? infoColor : secondaryTextColor,
                        size: ResponsiveUtils.iconSize(context, 20.0),
                      ),
              ),
            ),
            if (!isSelected)
              Text(
                label,
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 10),
                  color: secondaryTextColor,
                ),
              ),
          ],
        ),
      ),
    );

    _navItemCache[index] = navItem;
    return navItem;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveUtils.height(context, 85.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x1A000000),
            offset: Offset(0.0, -2.0),
            spreadRadius: 0.0,
          )
        ],
      ),
      child: Padding(
        padding: ResponsiveUtils.padding(
          context,
          horizontal: 16.0,
          vertical: 0.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home_rounded,
              label: FFLocalizations.of(context).getText('xgxiwbz2'),
              index: 0,
              onTap: () async {
                _navigationService.navigateToUserHome(context);
              },
            ),
            _buildNavItem(
              icon: Icons.subscriptions,
              label: FFLocalizations.of(context).getText('subscription'),
              index: 1,
              onTap: () async {
                _navigationService.navigateToSubscription(context);
              },
              isFontAwesome: true,
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              label: FFLocalizations.of(context).getText('yrbvaao0'),
              index: 3,
              onTap: () async {
                _navigationService.navigateToUserProfile(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
