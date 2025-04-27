import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class StandardTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final GlobalKey? fieldKey;

  const StandardTextFormField({
    super.key,
    VoidCallback? onTap,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: fieldKey,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        obscureText: false,
        onTap: () {
          // Move cursor to end of text
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        },
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: AppStyles.textCairo(
            context,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          hintText: hintText,
          hintStyle: AppStyles.textCairo(
            context,
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 12,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 20,
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
        ),
        style: AppStyles.textCairo(
          context,
        ),
        minLines: 1,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}

class MacroInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final IconData icon;
  final Color color;

  const MacroInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.25,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            labelText,
            style: AppStyles.textCairo(
              context,
              fontSize: 12,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextFormField(
            onTap: () {
              // Move cursor to end of text
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            },
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: AppStyles.textCairo(
              context,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              hintText: '0',
              hintStyle: AppStyles.textCairo(
                context,
                color:
                    FlutterFlowTheme.of(context).secondaryText.withAlpha(150),
                fontSize: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: color,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              errorStyle: AppStyles.textCairo(
                context,
                fontSize: 11,
                color: FlutterFlowTheme.of(context).error,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return FFLocalizations.of(context).getText('required');
              }
              if (int.tryParse(value) == null) {
                return FFLocalizations.of(context).getText('invalid');
              }
              if (double.parse(value) < 0) {
                return FFLocalizations.of(context)
                    .getText('error_negative_price');
              }
              if (double.parse(value) > 1000) {
                return FFLocalizations.of(context).getText('value_too_high');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class SectionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SectionContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primaryText.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsetsDirectional.all(20),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: FlutterFlowTheme.of(context).primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppStyles.textCairo(
                context,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ],
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
