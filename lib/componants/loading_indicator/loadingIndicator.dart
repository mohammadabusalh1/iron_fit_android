import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          width: 150.0,
          height: 150.0,
          child: Lottie.asset('assets/lottie/page_loading.json'),
        ),
      ),
    );
  }
}
