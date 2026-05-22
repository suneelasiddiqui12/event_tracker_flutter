# Event Tracker Flutter SDK

Cross-platform Flutter plugin for integrating the XNotify Event Tracker SDK on both Android and iOS.

---

# Features

- Event tracking
- User identification
- Anonymous session tracking
- Page/screen tracking
- Manual event flushing
- Supports Android & iOS with a single Flutter package

---

# Installation

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
  event_tracker_flutter: ^1.0.2
```

Then run:

```bash
flutter pub get
```

---

# Android Additional Setup (Required)

Since the Android SDK dependency is hosted on JitPack, you must add the JitPack repository in your Android project.

## Step 1 — Open

```text
android/settings.gradle.kts
```

Inside:

```kotlin
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)
    repositories {
        google()
        mavenCentral()

        // Add this line
        maven { url = uri("https://jitpack.io") }
    }
}
```

---

## Step 2 — Open

```text
android/build.gradle.kts
```

If your project declares repositories there, add:

```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()

        // Add this line
        maven { url = uri("https://jitpack.io") }
    }
}
```

---

# iOS Additional Setup

Minimum supported iOS version:

## Open

```text
ios/Podfile
```

Ensure:

```ruby
platform :ios, '13.0'
```

Then run:

```bash
cd ios
pod install
```

---

# Import

```dart
import 'package:event_tracker_flutter/event_tracker_flutter.dart';
```

---

# Initialize SDK

Initialize once during app startup:

```dart
await EventTrackerFlutter.initialize(
  eventKey: 'YOUR_EVENT_KEY',
  debug: false,
);
```

---

# Track Events

```dart
await EventTrackerFlutter.track(
  eventName: 'button_clicked',
  properties: {
    'button_name': 'login',
  },
);
```

---

# Identify User

```dart
await EventTrackerFlutter.identify(
  contactNumber: '923001234567',
  traits: {
    'name': 'John Doe',
    'email': 'john@example.com',
  },
);
```

---

# Anonymous Identification

```dart
await EventTrackerFlutter.identifyAnonymous(
  sessionId: 'guest_session_001',
  traits: {
    'user_type': 'guest',
  },
);
```

---

# Track Page / Screen

```dart
await EventTrackerFlutter.page(
  'Home Screen',
  properties: {
    'source': 'bottom_navigation',
  },
);
```

---

# Flush Events

```dart
await EventTrackerFlutter.flush();
```

---

# Example Initialization

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EventTrackerFlutter.initialize(
    eventKey: 'YOUR_EVENT_KEY',
    debug: false,
  );

  runApp(const MyApp());
}
```

---

# Notes

- Set `debug: true` only during development.
- Avoid enabling debug logs in production builds.
- Ensure internet connectivity for event delivery.

---

# Recent Updates

## Version 1.0.1

- Removed sensitive event keys from the example application.
- Improved public package security and demo configuration.
- Cleaned SDK debug logging to avoid exposing sensitive information.
- Added support for safe debug mode handling.
- Updated README with complete Android and iOS integration steps.
- Added JitPack integration instructions for Android projects.
- Improved Flutter package structure and plugin configuration.
- Fixed iOS framework integration and podspec configuration.
- Added cross-platform support for:
  - initialize()
  - identify()
  - identifyAnonymous()
  - track()
  - page()
  - flush()

---

# Support

For integration support or issues, please contact the XNotify team.