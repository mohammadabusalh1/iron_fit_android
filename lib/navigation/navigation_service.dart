import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Centralized navigation service to manage app navigation
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Navigate to a named route
  void navigateTo(BuildContext context, String routeName) {
    context.pushNamed(routeName);
  }

  /// Navigate to User Home
  void navigateToUserHome(BuildContext context) {
    context.pushNamed('UserHome');
  }

  /// Navigate to User Profile
  void navigateToUserProfile(BuildContext context) {
    context.pushNamed('userProfile');
  }

  /// Navigate to Subscription page
  void navigateToSubscription(BuildContext context) {
    context.pushNamed('mySubscription');
  }

  /// Navigate to Coach Home
  void navigateToCoachHome(BuildContext context) {
    context.pushNamed('CoachHome');
  }

  void navigateToCoachFeatures(BuildContext context) {
    context.pushNamed('coachFeatures');
  }

  /// Navigate to Coach Trainees
  void navigateToCoachTrainees(BuildContext context) {
    context.pushNamed('trainees');
  }

  /// Navigate to Coach Plans
  void navigateToCoachPlans(BuildContext context) {
    context.pushNamed('plansRoutes');
  }

  void navigateToMessages(BuildContext context) {
    context.pushNamed('Mesagess');
  }

  /// Navigate to Coach Analytics
  void navigateToCoachAnalytics(BuildContext context) {
    context.pushNamed('coachAnalytics');
  }

  /// Navigate to Coach Profile
  void navigateToCoachProfile(BuildContext context) {
    context.pushNamed('CoachProfile');
  }
}
