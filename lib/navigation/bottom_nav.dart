import 'package:flutter/material.dart';
import 'package:iron_fit/componants/coach_nav/coach_nav_widget.dart';
import 'package:iron_fit/componants/user_nav/user_nav_widget.dart';
import 'package:iron_fit/navigation/navigation_service.dart';

/// Nav bar type enum to distinguish between user and coach navigation bars
enum NavBarType {
  user,
  coach,
}

/// A reusable bottom navigation bar that can be used across the app
class AppBottomNavigationBar extends StatelessWidget {
  final NavBarType type;
  final int currentIndex;

  /// Navigation service for handling navigation
  static final NavigationService _navigationService = NavigationService();

  const AppBottomNavigationBar({
    super.key,
    required this.type,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case NavBarType.user:
        return UserNavWidget(num: currentIndex);

      case NavBarType.coach:
        return CoachNavWidget(
          pageNum: currentIndex,
          onItemTapped: (index) => _onCoachNavItemTapped(context, index),
        );
    }
  }

  /// Handle coach navigation item taps
  void _onCoachNavItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        _navigationService.navigateToCoachHome(context);
        break;
      case 1:
        _navigationService.navigateToCoachFeatures(context);
        break;
      case 2:
        _navigationService.navigateToMessages(context);
        break;
      case 3:
        _navigationService.navigateToCoachProfile(context);
        break;
    }
  }
}

/// Extension on Scaffold for easy bottom nav bar integration
extension ScaffoldWithNavBar on Scaffold {
  /// Creates a new scaffold with the appropriate bottom nav bar
  Scaffold withBottomNavBar({
    required NavBarType type,
    required int currentIndex,
  }) {
    return Scaffold(
      key: key,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      bottomNavigationBar: AppBottomNavigationBar(
        type: type,
        currentIndex: currentIndex,
      ),
    );
  }
}
