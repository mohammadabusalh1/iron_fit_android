import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iron_fit/utils/responsive_utils.dart';


class CreateAccountButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateAccountButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: FadeIn(
          duration: const Duration(milliseconds: 400),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.height(context, 16),
                horizontal: ResponsiveUtils.width(context, 16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: FlutterFlowTheme.of(context).primary,
            ),
            child: Icon(
              Icons.person_add,
              color: FlutterFlowTheme.of(context).black.withOpacity(0.8),
              size: ResponsiveUtils.iconSize(context, 24),
            ),
          ),
        ),
      ),
    );
  }
}
