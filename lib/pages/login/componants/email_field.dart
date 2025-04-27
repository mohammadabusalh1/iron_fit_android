import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final Function(String)? onFieldSubmitted;

  const EmailField({
    super.key,
    required this.controller,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: _EmailTextField(),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField();

  @override
  Widget build(BuildContext context) {
    final EmailField emailField =
        context.findAncestorWidgetOfExactType<EmailField>()!;

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
        //   emailField.controller.selection = TextSelection.fromPosition(
        //     TextPosition(offset: emailField.controller.text.length),
        //   );
        // },
        key: const Key('login_email'),
        controller: emailField.controller,
        focusNode: emailField.focusNode,
        autofocus: false,
        textInputAction: TextInputAction.next,
        obscureText: false,
        style: AppStyles.textCairo(
          context,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              Icons.email_outlined,
              color:
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.7),
              size: 22,
            ),
          ),
          hintText: FFLocalizations.of(context)
              .getText('u8sdx4sw' /* abc@gmail.com */),
          hintStyle: AppStyles.textCairo(
            context,
            color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.6),
            fontWeight: FontWeight.w400,
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
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        validator: emailField.validator,
        onFieldSubmitted: emailField.onFieldSubmitted,
      ),
    );
  }
}
