import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:iron_fit/componants/Styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 88,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              FlutterFlowTheme.of(context).primary.withAlpha(15),
              FlutterFlowTheme.of(context).primaryBackground,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.fitness_center,
              color: FlutterFlowTheme.of(context).primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FFLocalizations.of(context)
                    .getText('ue602o8f'), // Today's Workout
                style: AppStyles.textCairo(
                  context,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              Text(
                DateFormat('yyyy/MM/dd').format(DateTime.now()),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 14,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: FlutterFlowIconButton(
            borderColor: FlutterFlowTheme.of(context).primary.withAlpha(15),
            borderRadius: 12,
            borderWidth: 1,
            buttonSize: 48,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            icon: Icon(
              Icons.close,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
        ),
      ],
      centerTitle: false,
      elevation: 0,
    );
  }
}
