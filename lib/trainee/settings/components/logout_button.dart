import 'package:flutter/material.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({
    super.key,
    required this.onLogout,
  });

  final VoidCallback onLogout;

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
    final errorColor = FlutterFlowTheme.of(context).error;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) {
          _animationController.forward();
        },
        onTapUp: (_) {
          _animationController.reverse();
          widget.onLogout();
        },
        onTapCancel: () {
          _animationController.reverse();
        },
        child: Container(
          width: double.infinity,
          height: ResponsiveUtils.height(context, 58),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                errorColor.withOpacity(0.8),
                errorColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
            boxShadow: [
              BoxShadow(
                color: errorColor.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                right: ResponsiveUtils.width(context, -15),
                top: ResponsiveUtils.height(context, -15),
                child: Container(
                  width: ResponsiveUtils.width(context, 60),
                  height: ResponsiveUtils.height(context, 60),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: ResponsiveUtils.width(context, -20),
                bottom: ResponsiveUtils.height(context, -20),
                child: Container(
                  width: ResponsiveUtils.width(context, 70),
                  height: ResponsiveUtils.height(context, 70),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: ResponsiveUtils.iconSize(context, 20),
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 10)),
                    Text(
                      FFLocalizations.of(context).getText('logout'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
