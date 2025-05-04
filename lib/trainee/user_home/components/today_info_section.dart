import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TodayInfoSection extends StatelessWidget {
  final Animation<double> animation;

  const TodayInfoSection({
    required this.animation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Cache the content that doesn't need to rebuild with animation
    final content = _buildContent(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(100 * (1 - animation.value), 0),
          child: Opacity(
            opacity: animation.value,
            child: content,
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    // Cache formatted date values to avoid recomputation on each build
    final formattedDate = FFLocalizations.of(context).languageCode == 'ar'
        ? dateTimeFormat(
            'MMMM, yyyy',
            DateTime.now(),
            locale: const Locale('ar').toString(),
          )
        : dateTimeFormat('MMMM, yyyy', DateTime.now());

    return Padding(
      padding: ResponsiveUtils.padding(context, vertical: 16, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FFLocalizations.of(context).getText('today_info'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 24),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          Text(
            formattedDate,
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
