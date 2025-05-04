import 'package:flutter/material.dart';
import 'package:iron_fit/Ad/AdService.dart';
import 'package:iron_fit/componants/CheckSubscribe/check_subscribe.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlansHeader extends StatelessWidget {
  final CoachRecord? coach;
  final AdService adService;

  const PlansHeader({
    super.key,
    required this.coach,
    required this.adService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final localizations = FFLocalizations.of(context);

    const animDuration = Duration(milliseconds: 400);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.pushNamed('coachFeatures'),
              child: Icon(
                Icons.arrow_back,
                color: theme.info,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
            ),
            SizedBox(width: ResponsiveUtils.width(context, 12)),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.getText('8hnaygrm'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 20),
                    color: theme.info,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  localizations.getText('fglksp95'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    color: const Color(0xFFE0E0E0),
                  ),
                ),
              ],
            ),
          ],
        ),
        FlutterFlowIconButton(
          borderRadius: ResponsiveUtils.width(context, 8.0),
          buttonSize: ResponsiveUtils.width(context, 45.0),
          fillColor: theme.primary,
          icon: Icon(
            Icons.add,
            color: theme.info,
            size: ResponsiveUtils.iconSize(context, 24.0),
          ),
          onPressed: () => _onAddPlanPressed(context),
        ),
      ],
    )
        .animate()
        .fade(duration: animDuration)
        .slideX(begin: -0.25, duration: animDuration);
  }

  Future<void> _onAddPlanPressed(BuildContext context) async {
    if (coach?.isSub == true) {
      context.pushNamed('createExercisePlan');
    } else {
      await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CheckSubscribe(
            showInterstitialAd: () {
              adService.showInterstitialAd(context);
            },
            page: 'createExercisePlan',
          );
        },
      );
    }
  }
}
