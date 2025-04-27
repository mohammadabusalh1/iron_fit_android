import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const PasswordField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisibility = false;
  double _passwordStrength = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePasswordStrength);
    super.dispose();
  }

  void _updatePasswordStrength() {
    setState(() {
      _passwordStrength = estimatePasswordStrength(widget.controller.text);
    });
  }

  double estimatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;
    // Award points for length
    strength += password.length * 0.05;

    // Award points for complexity
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.2;

    // Cap the strength at 1.0
    return strength.clamp(0.0, 1.0);
  }

  String _getPasswordStrengthLabel(double strength) {
    if (strength < 0.3) return FFLocalizations.of(context).getText('weak');
    if (strength < 0.7) return FFLocalizations.of(context).getText('medium');
    return FFLocalizations.of(context).getText('strong');
  }

  Color _getPasswordStrengthColor(double strength) {
    if (strength < 0.3) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.slideAnimation,
      child: FadeTransition(
        opacity: widget.fadeAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              // onTap: () {
              //   widget.controller.selection = TextSelection.fromPosition(
              //     TextPosition(offset: widget.controller.text.length),
              //   );
              // },
              key: const Key('sign_up_password'),
              controller: widget.controller,
              focusNode: widget.focusNode,
              autofocus: false,
              textInputAction: TextInputAction.done,
              obscureText: !_passwordVisibility,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.7),
                  size: 20,
                ),
                hintText:
                    FFLocalizations.of(context).getText('be7jrni4' /* *** */),
                hintStyle: AppStyles.textCairo(context,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontWeight: FontWeight.w700),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        FlutterFlowTheme.of(context).alternate.withOpacity(0.5),
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
                suffixIcon: InkWell(
                  onTap: () => setState(
                      () => _passwordVisibility = !_passwordVisibility),
                  focusNode: FocusNode(skipTraversal: true),
                  child: Icon(
                    _passwordVisibility
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 20.0,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return FFLocalizations.of(context)
                      .getText('passwordIsRequired');
                }
                if (value.length <= 6) {
                  return FFLocalizations.of(context)
                      .getText('passwordMustBeAtLeast6Characters');
                }
                if (_passwordStrength < 0.3) {
                  return FFLocalizations.of(context)
                      .getText('passwordIsTooWeak');
                }
                return null;
              },
            ),
            if (widget.controller.text.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _passwordStrength,
                            backgroundColor:
                                FlutterFlowTheme.of(context).alternate,
                            color: _getPasswordStrengthColor(_passwordStrength),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getPasswordStrengthLabel(_passwordStrength),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 12,
                            color: _getPasswordStrengthColor(_passwordStrength),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      FFLocalizations.of(context).getText(
                          'passwordMustContainAtLeast6Characters' /* Password must contain at least 6 characters */),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 12,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
