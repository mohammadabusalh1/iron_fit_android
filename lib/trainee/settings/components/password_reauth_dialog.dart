import 'package:flutter/material.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class PasswordReauthDialog extends StatefulWidget {
  const PasswordReauthDialog({
    super.key,
  });

  @override
  State<PasswordReauthDialog> createState() => _PasswordReauthDialogState();
}

class _PasswordReauthDialogState extends State<PasswordReauthDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isObscured = true;
  String? _password;
  bool _isPasswordValid = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Responsive SizedBox and EdgeInsets
  late SizedBox _sizedBox8;
  late SizedBox _sizedBox12;
  late SizedBox _sizedBox16;
  late SizedBox _sizedBox24;
  late EdgeInsetsGeometry _contentPadding;
  late EdgeInsetsGeometry _dialogPadding;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    );
    _animationController.forward();

    _passwordController.addListener(_validatePassword);

    // Auto focus the password field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _passwordFocusNode.requestFocus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize responsive widgets
    _sizedBox8 = SizedBox(height: ResponsiveUtils.height(context, 8));
    _sizedBox12 = SizedBox(width: ResponsiveUtils.width(context, 12));
    _sizedBox16 = SizedBox(height: ResponsiveUtils.height(context, 16));
    _sizedBox24 = SizedBox(height: ResponsiveUtils.height(context, 24));
    _contentPadding = ResponsiveUtils.padding(
      context,
      horizontal: 16,
      vertical: 16,
    );
    _dialogPadding = ResponsiveUtils.padding(
      context,
      horizontal: 24,
      vertical: 24,
    );
  }

  void _validatePassword() {
    setState(() {
      _isPasswordValid = _passwordController.text.trim().length >= 6;
    });
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validatePassword);
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(ResponsiveUtils.width(context, 20));
    final inputBorderRadius = BorderRadius.circular(ResponsiveUtils.width(context, 14));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: _dialogPadding,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: ResponsiveUtils.width(context, 70),
                    height: ResponsiveUtils.height(context, 70),
                    decoration: BoxDecoration(
                      color:
                          FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: ResponsiveUtils.iconSize(context, 32),
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
                _sizedBox16,
                Text(
                  FFLocalizations.of(context).getText('reauth_required'),
                  style: AppStyles.textCairo(
                    context,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.fontSize(context, 20),
                  ),
                ),
                _sizedBox8,
                Text(
                  FFLocalizations.of(context).getText('reauth_message'),
                  style: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                  ),
                ),
                _sizedBox16,
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    hintText: FFLocalizations.of(context).getText('be7jrni4'),
                    hintStyle: AppStyles.textCairo(
                      context,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
                    prefixIcon: Icon(
                      Icons.password_rounded,
                      color: _passwordFocusNode.hasFocus
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).secondaryText,
                      size: ResponsiveUtils.iconSize(context, 20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1,
                      ),
                      borderRadius: inputBorderRadius,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: inputBorderRadius,
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    contentPadding: _contentPadding,
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      child: Icon(
                        _isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: ResponsiveUtils.iconSize(context, 22),
                      ),
                    ),
                  ),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                  ),
                  onFieldSubmitted: (_) {
                    if (_isPasswordValid) {
                      _password = _passwordController.text.trim();
                      _animationController.reverse().then((_) {
                        Navigator.of(context).pop(_password);
                      });
                    }
                  },
                ),
                _sizedBox24,
                Row(
                  children: [
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () {
                          _animationController.reverse().then((_) {
                            Navigator.of(context).pop();
                          });
                        },
                        text: FFLocalizations.of(context).getText('cancel'),
                        options: FFButtonOptions(
                          height: ResponsiveUtils.height(context, 50),
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle: AppStyles.textCairo(
                            context,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: ResponsiveUtils.fontSize(context, 14),
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2,
                          ),
                          borderRadius: inputBorderRadius,
                        ),
                      ),
                    ),
                    _sizedBox12,
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: _isPasswordValid
                            ? () {
                                _password = _passwordController.text.trim();
                                _animationController.reverse().then((_) {
                                  Navigator.of(context).pop(_password);
                                });
                              }
                            : null,
                        text: FFLocalizations.of(context).getText('confirm'),
                        options: FFButtonOptions(
                          height: ResponsiveUtils.height(context, 50),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: AppStyles.textCairo(
                            context,
                            color: Colors.white,
                            fontSize: ResponsiveUtils.fontSize(context, 14),
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 0,
                          borderRadius: inputBorderRadius,
                          disabledColor: FlutterFlowTheme.of(context)
                              .alternate
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
