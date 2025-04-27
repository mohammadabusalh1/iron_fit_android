import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Cache theme values to avoid repeated lookups
class ThemeCache {
  final Color primaryColor;
  final Color primaryBackgroundColor;
  final Color secondaryBackgroundColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color errorColor;
  final Color infoColor;

  ThemeCache(BuildContext context)
      : primaryColor = FlutterFlowTheme.of(context).primary,
        primaryBackgroundColor = FlutterFlowTheme.of(context).primaryBackground,
        secondaryBackgroundColor =
            FlutterFlowTheme.of(context).secondaryBackground,
        primaryTextColor = FlutterFlowTheme.of(context).primaryText,
        secondaryTextColor = FlutterFlowTheme.of(context).secondaryText,
        errorColor = FlutterFlowTheme.of(context).error,
        infoColor = FlutterFlowTheme.of(context).info;
}
