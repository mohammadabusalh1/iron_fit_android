import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;

  // Constant border radius for all borders
  static const BorderRadius _borderRadius =
      BorderRadius.all(Radius.circular(12));

  // Constant content padding
  static const EdgeInsets _contentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Get theme colors once to avoid multiple theme lookups
    final theme = FlutterFlowTheme.of(context);
    final alternateColor = theme.alternate;
    final primaryColor = theme.primary;
    final errorColor = theme.error;
    final secondaryBgColor = theme.secondaryBackground;
    final primaryTextColor = theme.primaryText;
    final infoColor = theme.info;
    final secondaryTextColor = theme.secondaryText;

    // Create border objects only once per build
    final defaultBorder = OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(
        color: alternateColor,
        width: 1,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(
        color: primaryColor,
        width: 2,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(
        color: errorColor,
        width: 1,
      ),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(
        color: errorColor,
        width: 2,
      ),
    );

    // Create text styles only once
    final labelStyle = AppStyles.textCairo(
      context,
      color: infoColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    final hintStyle = AppStyles.textCairo(
      context,
      color: secondaryTextColor.withAlpha(150),
      fontSize: 14,
    );

    final inputStyle = AppStyles.textCairo(
      context,
      fontSize: 14,
      color: primaryTextColor,
    );

    // Create decoration once
    final inputDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: _contentPadding,
      border: defaultBorder,
      enabledBorder: defaultBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      filled: true,
      fillColor: secondaryBgColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          minLines: minLines,
          maxLines: maxLines ?? minLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          decoration: inputDecoration,
          style: inputStyle,
          validator: validator,
        ),
      ],
    );
  }
}
