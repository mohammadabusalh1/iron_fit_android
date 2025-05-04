# iOS Firebase Cloud Messaging Setup Guide

This guide explains how to properly configure Firebase Cloud Messaging (FCM) for your iOS application.

## Prerequisites

1. Firebase project set up in Firebase Console
2. Flutter project with Firebase dependencies

## Configuration Steps

### 1. Add Required Dependencies

Ensure these dependencies are in your `pubspec.yaml`:

```yaml
dependencies:
  firebase_messaging: ^15.1.3
  flutter_local_notifications: ^18.0.1
  firebase_core: 3.6.0
```

### 2. iOS-Specific Configuration

#### 2.1 Update Info.plist

The following keys have been added to your `Info.plist`:

```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<true/>
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
    <string>processing</string>
</array>
<key>NSUserNotificationsUsageDescription</key>
<string>We need to send you notifications related to your workout sessions and reminders.</string>
```

#### 2.2 Configure AppDelegate.swift

Update your `AppDelegate.swift` to include:

```swift
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    
    // Register for remote notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { granted, error in
          if granted {
            print("User notifications permission granted")
          } else {
            print("User notifications permission denied: \(String(describing: error))")
          }
        }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle successful registration with APNs
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  // MessagingDelegate method
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    // If needed, send this token to your application server
    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
  }
}
```

### 3. Setup Firebase Service Account

Make sure you have the `service_account.json` file in your assets folder. This file is needed for server-to-client push notification functionality.

1. Create a Firebase service account key:
   - Go to Firebase Console > Project Settings > Service Accounts
   - Click "Generate new private key"
   - Save the JSON file as `service_account.json`

2. Place the file in your project at `assets/service_account.json`

3. Update your `pubspec.yaml` to include this file:
   ```yaml
   assets:
     - assets/service_account.json
   ```

### 4. Apple Push Notification Service (APNs) Setup

1. Create an Apple Push Notification Authentication Key:
   - Go to Apple Developer Account > Certificates, Identifiers & Profiles
   - Select "Keys" and add a new key
   - Enable "Apple Push Notifications service (APNs)"
   - Download the key and note the Key ID

2. Upload the APNs key to Firebase:
   - Go to Firebase Console > Project Settings > Cloud Messaging
   - Under Apple app configuration, click "Upload"
   - Upload your APNs key and fill in your Apple Team ID

### 5. Testing Push Notifications

After setup, you can test push notifications in several ways:

1. Using the iOS Simulator with Firebase emulator
2. Using a physical device
3. Using the Firebase Console to send test messages
4. Using the code in `FirebaseNotificationService` to send programmatic notifications

### Common Issues

- Make sure your app has proper entitlements for push notifications
- Verify that the Bundle ID in Firebase matches your iOS app's Bundle ID
- Check that your APNs key is valid and correctly uploaded to Firebase
- Ensure your device is registered for remote notifications

### Additional Resources

- [Firebase iOS Setup Guide](https://firebase.google.com/docs/ios/setup)
- [Flutter FCM Documentation](https://firebase.flutter.dev/docs/messaging/overview)
- [Apple Push Notification Service](https://developer.apple.com/documentation/usernotifications) 