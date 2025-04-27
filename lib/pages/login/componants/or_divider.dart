import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:animate_do/animate_do.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsetsDirectional.only(start: 8),
              height: 1,
              color: FlutterFlowTheme.of(context).info.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            FFLocalizations.of(context).getText('24szukkz' /* OR */),
            style: AppStyles.textCairo(
              context,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: FlutterFlowTheme.of(context).info.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsetsDirectional.only(end: 8),
              height: 1,
              color: FlutterFlowTheme.of(context).info.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
