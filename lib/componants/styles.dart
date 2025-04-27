import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AppStyles {
  static TextStyle textCairo(BuildContext context,
      {double fontSize = 14,
      Color? color,
      FontWeight fontWeight = FontWeight.normal,
      FontStyle fontStyle = FontStyle.normal,
      TextDecoration? decoration,
      double? letterSpacing}) {
    color ??= FlutterFlowTheme.of(context).info;
    return GoogleFonts.cairo(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: 1.4,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle textCairoButton(double fontSize) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    );
  }
}
