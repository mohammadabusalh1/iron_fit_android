import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Function(String)? onFieldSubmitted;

  const EmailField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.fadeAnimation,
    required this.slideAnimation,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                // onTap: () {
                //   controller.selection = TextSelection.fromPosition(
                //     TextPosition(offset: controller.text.length),
                //   );
                // },
                key: const Key('sign_up_email'),
                controller: controller,
                focusNode: focusNode,
                autofocus: false,
                textInputAction: TextInputAction.next,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.7),
                    size: 20,
                  ),
                  hintText: FFLocalizations.of(context).getText('u8sdx4sw'),
                  hintStyle: AppStyles.textCairo(context,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontWeight: FontWeight.w700),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context)
                          .alternate
                          .withOpacity(0.5),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FFLocalizations.of(context)
                        .getText('emailIsRequired');
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return FFLocalizations.of(context)
                        .getText('pleaseEnterValidEmail');
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                style: AppStyles.textCairo(
                  context,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                onFieldSubmitted: onFieldSubmitted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
