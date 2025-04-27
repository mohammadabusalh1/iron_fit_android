import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DaysAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DaysAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: FlutterFlowTheme.of(context).tertiary,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          Text(
            FFLocalizations.of(context).getText('dv1k6pvj' /* My Trainees */),
            style: AppStyles.textCairo(
              context,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
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
  Size get preferredSize => const Size.fromHeight(70);
}
