import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BottomAnimatedSection extends StatelessWidget {
  final double maxHeight;

  const BottomAnimatedSection({
    super.key,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          bottom: maxHeight * 0.13,
          left: 0,
          right: 0,
          child: Lottie.asset(
            'assets/lottie/bakground.json',
            width: MediaQuery.sizeOf(context).width,
            height: maxHeight * 0.3,
            fit: BoxFit.fitWidth,
            animate: true,
            repeat: true,
          ),
        ),
        Image.asset(
          'assets/images/preLogin2.png',
          width: double.infinity,
          fit: BoxFit.cover,
          height: maxHeight * 0.56,
        ),
      ],
    );
  }
}
