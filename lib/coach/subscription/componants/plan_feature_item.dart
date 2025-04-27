import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';

class PlanFeatureItem extends StatelessWidget {
  final String featureText;

  const PlanFeatureItem({
    super.key,
    required this.featureText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          Icons.check_circle_outline,
          color: theme.success,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            featureText,
            style: AppStyles.textCairo(context),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
