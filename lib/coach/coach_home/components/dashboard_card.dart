import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;

  const DashboardCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: child,
    );
  }
}
