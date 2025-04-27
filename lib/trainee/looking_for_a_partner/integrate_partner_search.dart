import 'package:flutter/material.dart';
import 'index.dart';

/// Integration examples for the partner search feature
/// This file provides examples of how to use the partner search feature from the main app

/// Example 1: Add a button to the app to navigate to the partner search feature
class PartnerSearchButton extends StatelessWidget {
  final String buttonText;

  const PartnerSearchButton({
    super.key,
    this.buttonText = 'البحث عن شريك تدريب',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => navigateToPartnerSearchFeature(context),
      child: Text(buttonText),
    );
  }
}

/// Example 2: Add a tile to a dashboard
class PartnerSearchTile extends StatelessWidget {
  const PartnerSearchTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => navigateToPartnerSearchFeature(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon for feature
            Icon(
              Icons.people,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              'البحث عن شريك تدريب',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              'ابحث عن شركاء متاحين للتدريب معاً',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 3: Add a menu item to a drawer
ListTile buildPartnerSearchMenuItem(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.people),
    title: const Text('البحث عن شريك تدريب'),
    onTap: () {
      // Close drawer
      Navigator.pop(context);
      // Navigate to partner search feature
      navigateToPartnerSearchFeature(context);
    },
  );
}

/// Example 4: Add a tab to a bottom navigation bar
BottomNavigationBarItem buildPartnerSearchTab() {
  return const BottomNavigationBarItem(
    icon: Icon(Icons.people),
    label: 'شركاء',
  );
}

/// Example implementation for handling a tab selection
void handleTabSelection(BuildContext context, int index) {
  // Assuming partner search is at index 2
  if (index == 2) {
    navigateToPartnerSearchFeature(context);
  }
  // Handle other tabs...
}

/// Example 5: Integration with user profile
Widget buildUserAvailabilityStatus(BuildContext context, bool isAvailable) {
  return Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isAvailable ? Colors.green : Colors.grey,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        isAvailable ? 'متاح للتدريب' : 'غير متاح للتدريب',
        style: TextStyle(
          color: isAvailable ? Colors.green : Colors.grey,
          fontSize: 12,
        ),
      ),
      const Spacer(),
      TextButton(
        onPressed: () => navigateToPartnerSearchFeature(context),
        child: const Text('إدارة التوفر'),
      ),
    ],
  );
}
