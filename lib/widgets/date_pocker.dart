import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';

Future<void> buildShowDatePicker(
    void Function(String) changeValue, BuildContext context) async {
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: FlutterFlowTheme.of(context).primary,
            onPrimary: FlutterFlowTheme.of(context).info,
            surface: FlutterFlowTheme.of(context).secondaryBackground,
            onSurface: FlutterFlowTheme.of(context).primaryText,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: FlutterFlowTheme.of(context).primary,
            ),
          ),
          textTheme: TextTheme(
            headlineMedium: const TextStyle(fontSize: 18),
            bodyLarge: TextStyle(color: FlutterFlowTheme.of(context).info),
            bodyMedium: TextStyle(color: FlutterFlowTheme.of(context).info),
          ),
        ),
        child: child!,
      );
    },
  );

  if (date != null) {
    changeValue(date.toIso8601String().split('T')[0]);
  }
}
