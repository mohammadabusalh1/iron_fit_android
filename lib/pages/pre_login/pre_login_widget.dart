import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'components/auth_service.dart';
import 'components/header_section.dart';
import 'components/action_button.dart';
import 'components/bottom_animated_section.dart';

class PreLoginWidget extends StatelessWidget {
  PreLoginWidget({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    // Call secure check login after build
    WidgetsBinding.instance
        .addPostFrameCallback((_) => AuthService.secureCheckLogin(context));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff78a3be),
              FlutterFlowTheme.of(context)
                  .primary
                  .withOpacity(0.5), // Start color // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CirclePatternPainter(
                            animation: AlwaysStoppedAnimation(1.0)),
                      ),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: const IntrinsicHeight(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 24.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          HeaderSection(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0),
                          child: ActionButton(),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: BottomAnimatedSection(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
        ),
      ),
    );
  }
}

class CirclePatternPainter extends CustomPainter {
  final Animation<double> animation;

  CirclePatternPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw animated curved lines
    for (int i = 0; i < 6; i++) {
      final path = Path();
      final startY = size.height * 0.8 + (i * size.height * 0.15);
      final animatedOffset = animation.value * size.height * 0.15;

      path.moveTo(0, startY + (i % 2 == 0 ? animatedOffset : -animatedOffset));
      path.quadraticBezierTo(
        size.width * 0.5,
        startY + size.height * 0.2 + (animatedOffset * 2),
        size.width,
        startY + (i % 2 == 0 ? -animatedOffset : animatedOffset),
      );

      canvas.drawPath(path, paint);
    }

    // Draw animated circles
    final centerX = size.width * 0.0;
    final centerY = size.height * 0;
    final center = Offset(centerX, centerY);

    for (var i = 0; i < 4; i++) {
      final radius = 20.0 + (i * 25);
      final animatedRadius = radius + (sin(animation.value * pi * 2) * 5);
      canvas.drawCircle(center, animatedRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePatternPainter oldDelegate) => true;
}
