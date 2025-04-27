import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';

class LoginLink extends StatefulWidget {
  const LoginLink({super.key});

  @override
  State<LoginLink> createState() => _LoginLinkState();
}

class _LoginLinkState extends State<LoginLink>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          _animationController.forward();
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _animationController.reverse();
        });
      },
      child: GestureDetector(
        key: const ValueKey('goToLoginPage'),
        onTap: () {
          context.pushNamed('Login');
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).primaryBackground,
                      FlutterFlowTheme.of(context).secondaryBackground,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.2),
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                  border: Border.all(
                    color: _isHovered
                        ? FlutterFlowTheme.of(context).primary.withOpacity(0.5)
                        : FlutterFlowTheme.of(context)
                            .alternate
                            .withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login_rounded,
                      size: 18,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: FFLocalizations.of(context)
                                .getText('5f1qv9wo' /* Create Account */),
                            style: AppStyles.textCairo(
                              context,
                              fontWeight: FontWeight.w700,
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: 12,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
