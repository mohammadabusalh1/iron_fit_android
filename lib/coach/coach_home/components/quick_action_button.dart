import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final List<Color> gradient;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withAlpha(90),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: FlutterFlowTheme.of(context).info,
                size: 28.0,
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: 90,
              child: Text(
                label,
                style: AppStyles.textCairo(
                  context,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
