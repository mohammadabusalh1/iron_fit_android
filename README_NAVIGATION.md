# Iron Fit Navigation Bar Guide

This document explains how to use the centralized navigation system in the IronFit app.

## Overview

The navigation system consists of:

1. `NavigationService` - A centralized service for handling navigation
2. `AppBottomNavigationBar` - A reusable component for both navbars
3. `PageWrapper` - A wrapper that adds navigation bars to widgets
4. Extension methods for easy implementation

## Pages Updated

The following pages have been updated to use the new navigation system:

### Trainee Pages:
- User Profile (`lib/trainee/user_profile/user_profile_widget.dart`)
- User Home (`lib/trainee/user_home/user_home_widget.dart`)
- Subscription (`lib/trainee/subscription/subscription_widget.dart`)
- Days (`lib/trainee/days/days_widget.dart`)

### Coach Pages:
- Coach Analytics (`lib/coach/coach_analytics/coach_analytics_widget.dart`)
- Coach Home (`lib/coach/coach_home/coach_home_widget.dart`)
- Trainees (`lib/coach/trainees/trainees_widget.dart`)
- Coach Profile (`lib/coach/coach_profile/coach_profile_widget.dart`)
- Plans Routes (`lib/coach/plans_routes/plans_routes_widget.dart`)

## How to Use

### 1. On Coach Pages

Replace your custom bottom navigation implementation with the new system:

```dart
// OLD WAY
Widget build(BuildContext context) {
  return Scaffold(
    body: YourContent(),
    bottomNavigationBar: _buildBottomNav(),
  );
}

Widget _buildBottomNav() {
  return CoachNavWidget(
    pageNum: 3,
    onItemTapped: (index) => onNavItemTapped(context, index),
  );
}
```

```dart
// NEW WAY
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:iron_fit/navigation/bottom_nav.dart';

Widget build(BuildContext context) {
  return Scaffold(
    body: YourContent(),
  ).withCoachNavBar(3);
}
```

### 2. On User Pages

Replace your custom user navigation implementation:

```dart
// OLD WAY
Widget build(BuildContext context) {
  return Scaffold(
    body: YourContent(),
    bottomNavigationBar: wrapWithModel(
      model: _model.userNavModel,
      updateCallback: () => setState(() {}),
      child: const UserNavWidget(num: 1),
    ),
  );
}
```

```dart
// NEW WAY
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:iron_fit/navigation/bottom_nav.dart';

Widget build(BuildContext context) {
  return Scaffold(
    body: YourContent(),
  ).withUserNavBar(1);
}
```

### 3. For Widgets that aren't Scaffolds

You can wrap any widget with a navigation bar:

```dart
Widget build(BuildContext context) {
  return YourWidget().withUserNavBar(1);
  // OR
  return YourWidget().withCoachNavBar(2);
}
```

### 4. Navigation

Use the centralized NavigationService for consistent navigation:

```dart
// OLD WAY
context.pushNamed('UserHome');

// NEW WAY
import 'package:iron_fit/navigation/navigation_service.dart';

final NavigationService _navigationService = NavigationService();
_navigationService.navigateToUserHome(context);
```

## Benefits

1. **Consistent UI**: Navigation bars now look and behave the same throughout the app
2. **Easier maintenance**: Changes to navigation only need to be made in one place
3. **Less code**: Removed duplicate navigation bar logic from each page
4. **Performance**: Navigation components are optimized and cached when possible

## Navigation Bar Indexes

### User Navigation Bar
- 0: Home
- 1: Subscription
- 3: Profile

### Coach Navigation Bar
- 0: Home
- 1: Trainees
- 2: Plans
- 3: Analytics
- 4: Profile 