# System Info

**System Info** is a Flutter project that retrieves detailed hardware and system information from iOS and Android devices. The app utilizes **Method Channels** to enable communication between Flutter and native platforms.

## Features

- **Cross-platform Support**: Works on both iOS and Android devices.
- **Hardware Details**:
  - Device name, model, and system version.
  - Battery level.
  - CPU details.
  - Total and available storage capacity.
  - Physical RAM information.
- **Native Integration**:
  - Uses Flutter's Method Channels to interact with native code written in Swift (iOS) and Kotlin/Java (Android).

## Technology Stack

- **Frontend**: Flutter (Dart)
- **Native Code**:
  - Swift for iOS
  - Kotlin for Android

## How It Works

1. **Flutter Method Channel**:  
   A method channel (`com.system_info/device_info`) is created to enable communication between Flutter and the native code.
   
2. **Native Code Implementation**:
   - On **iOS**, hardware information is retrieved using APIs like `UIDevice`, `ProcessInfo`, and `FileManager`.
   - On **Android**, system details are fetched using Android SDK APIs like `Build` and `StatFs`.

3. **Data Transmission**:  
   The native code sends the hardware information back to Flutter as a structured JSON object, which can then be displayed in the Flutter UI.

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/mahsidak/system-info.git
