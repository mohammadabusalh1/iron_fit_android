import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class Material3TextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final String suffixText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final String title;

  const Material3TextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.suffixText,
    required this.keyboardType,
    required this.validator,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                prefixIcon,
                color: FlutterFlowTheme.of(context).primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              textAlign: TextAlign.start,
              title,
              style: AppStyles.textCairo(
                context,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            onTap: () {
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            },
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              labelStyle: AppStyles.textCairo(
                context,
                fontSize: 16,
                color: focusNode.hasFocus
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).secondaryText,
              ),
              hintStyle: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context)
                    .secondaryText
                    .withValues(alpha: 0.7),
              ),
              suffixText: suffixText,
              suffixStyle: AppStyles.textCairo(
                context,
                fontSize: 14,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1,
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
                  width: 1,
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
              contentPadding:
                  const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
            ),
            style: AppStyles.textCairo(
              context,
              fontSize: 16,
            ),
            cursorColor: FlutterFlowTheme.of(context).primary,
          ),
        )
      ],
    );
  }
}
