import 'package:flutter/material.dart';
import 'package:iron_fit/componants/styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CoachAppBar {
  static AppBar coachAppBar(BuildContext context, String title,
      IconButton? prefixIcon, IconButton? suffixIcon) {
    final theme = FlutterFlowTheme.of(context);
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 6,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          title,
          key: ValueKey(title),
          style: AppStyles.textCairo(
            context,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.primaryText,
          ),
        ),
      ),
      leading: prefixIcon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: prefixIcon,
            )
          : null,
      actions: [
        if (suffixIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: suffixIcon,
          ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          gradient: LinearGradient(
            colors: [
              theme.primary.withOpacity(0.9),
              theme.tertiary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }
}
