import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/componants/Styles.dart';

class CoachMessagesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CoachMessagesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: FlutterFlowTheme.of(context).tertiary,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Empty for balance
          const SizedBox(width: 48),
          // Center - Title
          Text(
            FFLocalizations.of(context).getText('kqnehly5'),
            style: AppStyles.textCairo(
              context,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          // Right side - Optional button/icon
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24,
            ),
            onPressed: () {
              context.pushNamed('Contact');
            },
          ),
        ],
      ),
      centerTitle: true,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      toolbarHeight: 70,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
