import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;

  const PasswordField({
    super.key,
    required this.controller,
    this.focusNode,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return _PasswordTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      passwordVisibility: _passwordVisibility,
      onToggleVisibility: () {
        setState(() {
          _passwordVisibility = !_passwordVisibility;
        });
      },
    );
  }
}

// Extracted stateless widget to avoid rebuilding the entire form
class _PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final bool passwordVisibility;
  final VoidCallback onToggleVisibility;

  const _PasswordTextField({
    required this.controller,
    this.focusNode,
    this.validator,
    required this.passwordVisibility,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        // onTap: () {
        //   controller.selection = TextSelection.fromPosition(
        //     TextPosition(offset: controller.text.length),
        //   );
        // },
        key: const Key('login_password'),
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        textInputAction: TextInputAction.done,
        obscureText: !passwordVisibility,
        style: AppStyles.textCairo(
          context,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              Icons.lock_outline,
              color:
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.7),
              size: 22,
            ),
          ),
          hintText: FFLocalizations.of(context).getText('be7jrni4' /* *** */),
          hintStyle: AppStyles.textCairo(
            context,
            color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.6),
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: InkWell(
            onTap: onToggleVisibility,
            focusNode: FocusNode(skipTraversal: true),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                passwordVisibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: FlutterFlowTheme.of(context).primary,
                size: 22,
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        validator: validator,
      ),
    );
  }
}
