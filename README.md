# PermissionKit

A modern, modular permission layer for iOS, written with Swift Concurrency and SwiftUI.

Every permission lives in its **own library product**, so an app links only what it actually uses. Unused products are never compiled into your binary — keeping your app free of system frameworks you don't need and your **Privacy Manifest** honest.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-26%2B-blue.svg)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Why PermissionKit

- **Modular by design** — one product per permission. Link `PermissionCamera` and you get AVFoundation; you don't drag in CoreLocation, Contacts, or HealthKit.
- **Async/await first** — a single `async` API across every permission, with legacy delegate/callback APIs wrapped behind `CheckedContinuation`.
- **Unified status model** — all of Apple's per-framework enums normalize into one `PermissionStatus` (`authorized`, `limited`, `provisional`, `denied`, `restricted`, `notDetermined`).
- **SwiftUI-ready** — `PermissionState` (an `ObservableObject`) and a drop-in `PermissionButton`.
- **Settings fallback built in** — `requestOrOpenSettings()` prompts on first use and routes to Settings once denied.

## Installation

### Swift Package Manager

In Xcode: **File ▸ Add Package Dependencies…** and enter:

```
https://github.com/theanvora/PermissionKit.git
```

Or in `Package.swift`:

```swift
.package(url: "https://github.com/theanvora/PermissionKit.git", from: "1.0.0")
```

Then add **only** the products you need:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "PermissionCamera", package: "PermissionKit"),
        .product(name: "PermissionPhotos", package: "PermissionKit"),
    ]
)
```

> When adding the package in Xcode, all products appear in the picker — **tick only the ones you use**. Unticked products are not compiled or linked into your app.

## Available Permissions

| Product | Framework | Required `Info.plist` key(s) |
|---|---|---|
| `PermissionCore` | — | _(shared types: `Permission`, `PermissionStatus`, `PermissionState`, `PermissionButton`, `PermissionSettings`)_ |
| `PermissionCamera` | AVFoundation | `NSCameraUsageDescription` |
| `PermissionMicrophone` | AVFoundation | `NSMicrophoneUsageDescription` |
| `PermissionPhotos` | Photos | `NSPhotoLibraryUsageDescription` / `NSPhotoLibraryAddUsageDescription` |
| `PermissionLocation` | CoreLocation | `NSLocationWhenInUseUsageDescription` / `NSLocationAlwaysAndWhenInUseUsageDescription` |
| `PermissionNotification` | UserNotifications | — |
| `PermissionContacts` | Contacts | `NSContactsUsageDescription` |
| `PermissionTracking` | AppTrackingTransparency | `NSUserTrackingUsageDescription` |
| `PermissionCalendar` | EventKit | `NSCalendarsUsageDescription` / `NSCalendarsWriteOnlyAccessUsageDescription` |
| `PermissionReminders` | EventKit | `NSRemindersUsageDescription` / `NSRemindersFullAccessUsageDescription` |
| `PermissionSpeech` | Speech | `NSSpeechRecognitionUsageDescription` |
| `PermissionBluetooth` | CoreBluetooth | `NSBluetoothAlwaysUsageDescription` |
| `PermissionMotion` | CoreMotion | `NSMotionUsageDescription` |
| `PermissionMusic` | MediaPlayer | `NSAppleMusicUsageDescription` |
| `PermissionSiri` | Intents | `NSSiriUsageDescription` |
| `PermissionBiometric` | LocalAuthentication | `NSFaceIDUsageDescription` |
| `PermissionHealth` | HealthKit | `NSHealthShareUsageDescription` / `NSHealthUpdateUsageDescription` + HealthKit entitlement |

## Usage

### Imperative (async/await)

```swift
import PermissionCamera

let status = await CameraPermission().request()
guard status.isAuthorized else { return }
// Proceed to open the camera.
```

`status()` reads the current grant without ever showing a prompt; `request()` shows the system dialog only when the user hasn't decided yet, and otherwise echoes the existing status.

### SwiftUI — `PermissionState`

```swift
import PermissionCore
import PermissionCamera

struct ScanView: View {
    @StateObject private var camera = PermissionState(CameraPermission())

    var body: some View {
        Button("Enable Camera") {
            Task { await camera.requestOrOpenSettings() }
        }
        .disabled(camera.isAuthorized)
        .task { await camera.refresh() }
    }
}
```

### SwiftUI — `PermissionButton`

A self-contained button that requests on tap and falls back to Settings when denied:

```swift
PermissionButton(PhotosPermission()) { status in
    Label("Photo Library", systemImage: status.isAuthorized ? "checkmark.circle" : "photo")
}
```

## The `PermissionStatus` model

| Case | Meaning |
|---|---|
| `notDetermined` | The system prompt has not been shown yet. |
| `authorized` | Full access granted. |
| `limited` | Partial access (e.g. selected photos or contacts). |
| `provisional` | Silently granted without a prompt (notifications). |
| `denied` | Explicitly refused by the user. |
| `restricted` | Locked down by the OS (Screen Time, MDM…). |

Convenience: `status.isAuthorized` and `status.shouldOpenSettings`.

## Adding your own permission

Create a target that depends on `PermissionCore`, conform to `Permission`, and map the framework's native status into `PermissionStatus`:

```swift
import PermissionCore

public struct MyPermission: Permission {
    public init() {}
    public var title: String { "My Feature" }

    public func status() async -> PermissionStatus { /* read native status */ }

    @discardableResult
    public func request() async -> PermissionStatus { /* request + map */ }
}
```

## Requirements

- iOS 26.0+
- Swift 5.9+ / Xcode 15+

## License

MIT
