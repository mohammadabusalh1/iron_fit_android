import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
            FlutterFlowTheme.of(context).primaryBackground,
          ],
        ),
      ),
    );
  }
}
