import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/partner_search_provider.dart';
import 'screens/partner_search_main_screen.dart';

/// Main entry point for the partner search feature
/// This widget provides the necessary provider and screens for the feature
class PartnerSearchFeature extends StatelessWidget {
  const PartnerSearchFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PartnerSearchProvider(),
      builder: (context, child) => const PartnerSearchMainScreen(),
    );
  }
}

/// Method to initialize the partner search feature and navigate to it
/// This can be called from any part of the app
void navigateToPartnerSearchFeature(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PartnerSearchFeature(),
    ),
  );
}
