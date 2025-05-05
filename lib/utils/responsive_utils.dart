import 'package:flutter/material.dart';

/// Utility class for responsive sizing across different screen sizes
class ResponsiveUtils {
  // Screen size breakpoints
  static const double kPhoneBreakpoint = 480.0;
  static const double kTabletBreakpoint = 768.0;
  static const double kDesktopBreakpoint = 1024.0;

  /// Returns true if the screen is considered a phone size
  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < kPhoneBreakpoint;
  }

  /// Returns true if the screen is considered a tablet size
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= kPhoneBreakpoint && width < kDesktopBreakpoint;
  }

  /// Returns true if the screen is considered a desktop size
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= kDesktopBreakpoint;
  }

  /// Returns a responsive font size based on screen width
  static double fontSize(BuildContext context, double baseFontSize) {
    if (isPhone(context)) {
      final screenSize = MediaQuery.of(context).size;
      return (screenSize.width * 0.003 * baseFontSize);
    } else if (isTablet(context)) {
      return baseFontSize * 1.15;
    } else {
      return baseFontSize * 1.25;
    }
  }

  /// Returns a responsive icon size based on screen width
  static double iconSize(BuildContext context, double baseIconSize) {
    if (isPhone(context)) {
      return baseIconSize;
    } else if (isTablet(context)) {
      return baseIconSize * 1.2;
    } else {
      return baseIconSize * 1.4;
    }
  }

  /// Returns responsive padding based on screen width
  static EdgeInsetsGeometry padding(
    BuildContext context, {
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    double horizontalFactor = 1.0;
    double verticalFactor = 1.0;

    if (isTablet(context)) {
      horizontalFactor = 1.25;
      verticalFactor = 1.2;
    } else if (isDesktop(context)) {
      horizontalFactor = 1.5;
      verticalFactor = 1.3;
    } else {
      final screenSize = MediaQuery.of(context).size;
      if (screenSize.width > 380) {
        horizontalFactor = 1.25;
        verticalFactor = 1.25;
      } else if (screenSize.width > 320) {
        horizontalFactor = 1.15;
        verticalFactor = 1.15;
      } else {
        horizontalFactor = 1.0;
        verticalFactor = 1.0;
      }
    }

    return EdgeInsets.symmetric(
      horizontal: horizontal * horizontalFactor,
      vertical: vertical * verticalFactor,
    );
  }

  /// Returns a responsive height value based on screen height
  static double height(BuildContext context, double baseHeight) {
    final screenHeight = MediaQuery.of(context).size.height;

    return (screenHeight * (0.00125 * baseHeight));
  }

  /// Returns a responsive width value based on screen width
  static double width(BuildContext context, double baseWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseScreenWidth = 360.0; // Base for comparison (phone width)

    return baseWidth * (screenWidth / baseScreenWidth);
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
