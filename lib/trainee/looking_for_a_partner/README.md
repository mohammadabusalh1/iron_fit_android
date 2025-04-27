# Partner Search Feature

## Overview
The Partner Search feature allows trainees to search for and connect with other trainees for joint training sessions. This feature enables users to set their availability status, search for available training partners, send training requests, and manage those requests.

## Key Features
- Set availability status and training preferences
- Search for available training partners using filters
- View detailed trainee profiles
- Send training partner requests
- Manage and respond to training requests

## Architecture
The feature follows a clean architecture with separation of concerns:
- **Models**: Data structures for trainees, requests, etc.
- **Providers**: State management using Provider pattern
- **Screens**: UI components for the different feature screens
- **Utils**: Common widgets and utilities

## How to Use

### 1. Integration

To integrate the feature into the main app, you can use the `PartnerSearchFeature` widget or the navigation helper:

```dart
// Using the PartnerSearchFeature widget
ChangeNotifierProvider(
  create: (context) => PartnerSearchProvider(),
  child: const PartnerSearchMainScreen(),
);

// Or using the navigation helper
navigateToPartnerSearchFeature(context);
```

### 2. Setting Availability

To make themselves visible to other trainees, users need to:
1. Navigate to the Activate Availability screen
2. Toggle the availability switch
3. Select their preferred training types
4. Set available training times
5. Optionally add additional notes
6. Save the settings

### 3. Searching for Partners

Users can search for training partners by:
1. Browsing the list of available trainees
2. Using the search bar to search by name
3. Filtering by training type preferences

### 4. Sending Training Requests

After finding a potential training partner, users can:
1. View the trainee's profile
2. Select a training type and time from the trainee's availability
3. Write a personalized message
4. Send the training request

### 5. Managing Requests

Users can manage their training requests:
1. View pending, accepted, rejected, and completed requests
2. Accept or reject incoming requests
3. View request details

## File Structure

```
lib/trainee/looking_for_a_partner/
├── index.dart                      # Main exports
├── partner_search_feature.dart     # Main feature entry point
├── integrate_partner_search.dart   # Integration helpers
├── README.md                       # Documentation
├── models/
│   └── partner_search_models.dart  # Data models
├── providers/
│   └── partner_search_provider.dart # State management
├── screens/
│   ├── partner_search_main_screen.dart    # Main screen
│   ├── activate_availability_screen.dart  # Availability settings
│   ├── partner_search_screen.dart         # Search for partners
│   ├── trainee_profile_screen.dart        # View trainee and send request
│   └── requests_management_screen.dart    # Manage requests
└── utils/
    └── partner_search_widgets.dart       # Common widgets
```

## Design Implementation
The feature follows the design guidelines including:
- Dark theme optimized for readability
- Bento grid layouts for visual organization
- Cairo font for Arabic text support
- Yellow primary color scheme
- Consistent card and input styles

## Localization
The feature currently supports Arabic with all text, labels, and messages provided in Arabic. The UI is also built with RTL support.

## Future Improvements
- Real-time updates for request status changes
- Chat functionality for accepted partners
- Calendar integration for training sessions
- Ratings and review system after training sessions
- Push notification support

## Dependencies
- `provider`: For state management
- `intl`: For date and time formatting
- `google_fonts`: For Cairo font support

## Testing
The feature includes mock data for testing purposes. In a production environment, this would be replaced with actual API calls.

## Contact
For questions or issues related to this feature, please contact the development team. 