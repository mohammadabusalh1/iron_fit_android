import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/navigation/bottom_nav.dart';

/// A wrapper widget that adds the appropriate bottom navigation bar to a page
class PageWrapper extends StatelessWidget {
  final Widget child;
  final NavBarType navBarType;
  final int currentIndex;

  /// Creates a new page wrapper
  const PageWrapper({
    super.key,
    required this.child,
    required this.navBarType,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the child is already a scaffold
    if (child is Scaffold) {
      // If it is, add the nav bar to it
      return (child as Scaffold).withBottomNavBar(
        type: navBarType,
        currentIndex: currentIndex,
      );
    }

    // If not, wrap it in a scaffold with the nav bar
    return Scaffold(
      body: child,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: AppBottomNavigationBar(
        type: navBarType,
        currentIndex: currentIndex,
      ),
    );
  }
}

/// Extension methods for widgets to add navigation bars
extension WidgetWithNavBar on Widget {
  /// Adds a user navigation bar to this widget
  Widget withUserNavBar(int currentIndex) {
    return PageWrapper(
      navBarType: NavBarType.user,
      currentIndex: currentIndex,
      child: this,
    );
  }

  /// Adds a coach navigation bar to this widget
  Widget withCoachNavBar(int currentIndex) {
    return PageWrapper(
      navBarType: NavBarType.coach,
      currentIndex: currentIndex,
      child: this,
    );
  }
}
