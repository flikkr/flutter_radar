# Flutter Detect

Flutter Detect is a project designed to detect and analyze Flutter applications, providing detailed information about their packages and dependencies.

## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/to/state-management-sample).

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How it works

Flutter Detect uses native Android capabilities to identify and analyze Flutter applications installed on a device. Here's how it works:

1. **Detection**: The app scans all installed applications on the device and identifies Flutter apps by looking for specific Flutter libraries (`libflutter.so` and `libapp.so`).

1. **Multiple Detection Methods**: The system employs several strategies to find Flutter libraries:
   - Checking in the native library directory
   - Examining ZIP entries in the app's APK
   - Looking in split configuration files for different architectures (ARM, x86)

1. **Package Analysis**: The app can extract and list all packages used by a Flutter application by:
   - Scanning the app's binary files for package references
   - Using regex patterns to identify package declarations
   - Parsing the extracted information into a structured format

This tool is particularly useful for developers who want to analyze Flutter apps, check for specific dependencies, or understand how Flutter applications are structured on Android devices.
