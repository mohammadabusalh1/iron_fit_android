import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/componants/user_nav/user_nav_widget.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EmptyPlanState extends StatelessWidget {
  final bool hasNav;

  const EmptyPlanState({
    super.key,
    this.hasNav = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: mediaQueryHeight,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ResponsiveUtils.height(context, mediaQueryHeight * 0.7),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.no_meals_outlined,
                          size: ResponsiveUtils.iconSize(context, 64),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        )
                            .animate()
                            .scale(duration: 400.ms)
                            .then()
                            .shake(duration: 400.ms),
                        SizedBox(height: ResponsiveUtils.height(context, 16)),
                        Text(
                          FFLocalizations.of(context)
                              .getText('no_active_plans_found'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: ResponsiveUtils.fontSize(context, 18),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasNav)
            const Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: UserNavWidget(num: 2),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
