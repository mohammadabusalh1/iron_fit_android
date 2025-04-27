import 'package:iron_fit/componants/Styles.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CoachNavWidget extends StatefulWidget {
  final int pageNum;
  final Function(int) onItemTapped;

  const CoachNavWidget({
    super.key,
    required this.pageNum,
    required this.onItemTapped,
  });

  @override
  State<CoachNavWidget> createState() => _CoachNavWidgetState();
}

class _CoachNavWidgetState extends State<CoachNavWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    bool showIndicator = true,
    VoidCallback? onLongPress,
  }) {
    final isSelected = widget.pageNum == index;
    final theme = FlutterFlowTheme.of(context);
    final selectedColor = theme.primary;
    final unselectedColor = theme.secondaryText;

    return Expanded(
      flex: 1,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: isSelected ? null : () => widget.onItemTapped(index),
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: showIndicator
                ? Border(
                    top: BorderSide(
                      color: isSelected ? selectedColor : Colors.transparent,
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? selectedColor : unselectedColor,
                size: 24.0,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppStyles.textCairo(
                  context,
                  fontSize: 10,
                  color: isSelected ? selectedColor : unselectedColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesItem(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isSelected = widget.pageNum == 1;
    final selectedColor = theme.primary;
    final unselectedColor = theme.secondaryText;

    return Expanded(
      flex: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: theme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigate directly to the features page
            widget.onItemTapped(1);
            HapticFeedback.lightImpact();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isSelected ? selectedColor : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Icon(
                      Icons.grid_view_rounded,
                      color: isSelected ? selectedColor : unselectedColor,
                      size: 20.0,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  FFLocalizations.of(context).getText('features_nav'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 10,
                    color: isSelected ? selectedColor : unselectedColor,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    final mainNavItems = [
      _buildNavItem(
        context: context,
        icon: Icons.home_rounded,
        label: FFLocalizations.of(context).getText('zhq8jv64'),
        index: 0,
      ),
      _buildFeaturesItem(context),
      _buildNavItem(
        context: context,
        icon: Icons.chat_rounded,
        label: FFLocalizations.of(context).getText('messages_nav'),
        index: 2,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.person,
        label: FFLocalizations.of(context).getText('p7e40md4'),
        index: 3,
      ),
    ];

    return Container(
      width: double.infinity,
      height: 70.0,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 8.0,
            color: Color(0x33000000),
            offset: Offset(0.0, -2.0),
            spreadRadius: 0.0,
          )
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: mainNavItems.divide(const SizedBox(width: 8.0)).toList(),
        ),
      ),
    );
  }
}
