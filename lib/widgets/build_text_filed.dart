import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

Widget buildTextField(
    {required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required String hintText,
    IconData? prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
    void Function(String)? onFieldSubmitted,
    TextInputAction? textInputAction,
    double? fontSize,
    double? iconSize,
    required BuildContext context}) {
  final defaultFontSize = 16.0;
  final defaultIconSize = 24.0;
  
  return TextFormField(
    keyboardType: keyboardType,
    maxLines: maxLines,
    minLines: maxLines,
    controller: controller,
    focusNode: focusNode,
    readOnly: readOnly,
    onTap: onTap,
    validator: validator,
    onFieldSubmitted: onFieldSubmitted,
    textInputAction: textInputAction,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: AppStyles.textCairo(
        context,
        fontSize: fontSize ?? ResponsiveUtils.fontSize(context, defaultFontSize),
        color: focusNode.hasFocus
            ? FlutterFlowTheme.of(context).primary
            : FlutterFlowTheme.of(context).secondaryText,
      ),
      hintText: hintText,
      hintStyle: AppStyles.textCairo(
        context,
        fontSize: fontSize ?? ResponsiveUtils.fontSize(context, defaultFontSize),
        color:
            FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.7),
      ),
      prefixIcon: prefixIcon != null
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                prefixIcon,
                color: focusNode.hasFocus
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).secondaryText,
                size: iconSize ?? ResponsiveUtils.iconSize(context, defaultIconSize),
              ),
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      contentPadding: ResponsiveUtils.padding(context, 
        horizontal: 20, 
        vertical: 24,
      ),
    ),
    style: AppStyles.textCairo(
      context, 
      fontSize: fontSize ?? ResponsiveUtils.fontSize(context, defaultFontSize)
    ),
    cursorColor: FlutterFlowTheme.of(context).primary,
  );
}
