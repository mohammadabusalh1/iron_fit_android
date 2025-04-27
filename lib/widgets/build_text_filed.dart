import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';

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
    required BuildContext context}) {
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
        fontSize: 16,
        color: focusNode.hasFocus
            ? FlutterFlowTheme.of(context).primary
            : FlutterFlowTheme.of(context).secondaryText,
      ),
      hintText: hintText,
      hintStyle: AppStyles.textCairo(
        context,
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
      contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
    ),
    style: AppStyles.textCairo(context, fontSize: 16),
    cursorColor: FlutterFlowTheme.of(context).primary,
  );
}
