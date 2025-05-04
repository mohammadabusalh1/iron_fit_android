import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:lottie/lottie.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({super.key});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cache the text style to avoid recreating it on every build
    final textStyle = GoogleFonts.poppins(
      fontSize: ResponsiveUtils.fontSize(context, 18),
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (mounted) {
                _controller.forward();
                setState(() => _isPressed = true);
              }
            },
            onTapUp: (_) {
              if (mounted) {
                _controller.reverse();
                setState(() => _isPressed = false);
              }
            },
            onTapCancel: () {
              if (mounted) {
                _controller.reverse();
                setState(() => _isPressed = false);
              }
            },
            onTap: () async {
              if (mounted && context.mounted) {
                await _controller.forward();
                if (!mounted) return;
                FFAppState().isFirstTme = false;
                context.goNamed('SignUp');
              }
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.height(context, 16),
                horizontal: ResponsiveUtils.width(context, 32),
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFAA00),
                    Color(0xFFFF7E00),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFAA00)
                        .withValues(alpha: _isPressed ? 0.2 : 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                    spreadRadius: _isPressed ? 1 : 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: textStyle,
                  ),
                  SizedBox(width: ResponsiveUtils.width(context, 16)),
                  Lottie.asset(
                    'assets/lottie/arrow_right.json',
                    width: ResponsiveUtils.width(context, 16),
                    height: ResponsiveUtils.height(context, 16),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
