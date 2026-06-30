# PermissionKit

Base xin quyền iOS viết bằng **async/await + SwiftUI**. Mỗi quyền là **một library product riêng**, project chỉ link cái cần → không kéo theo system framework thừa (sạch Privacy Manifest, App Store review).

## Products

| Product | Framework | Info.plist key |
|---|---|---|
| `PermissionCore` | — | (chung: `Permission`, `PermissionStatus`, `PermissionState`, `PermissionButton`, `PermissionSettings`) |
| `PermissionCamera` | AVFoundation | `NSCameraUsageDescription` |
| `PermissionMicrophone` | AVFoundation | `NSMicrophoneUsageDescription` |
| `PermissionPhotos` | Photos | `NSPhotoLibraryUsageDescription` / `NSPhotoLibraryAddUsageDescription` |
| `PermissionLocation` | CoreLocation | `NSLocationWhenInUseUsageDescription` / `…AlwaysAndWhenInUse…` |
| `PermissionNotification` | UserNotifications | — |
| `PermissionContacts` | Contacts | `NSContactsUsageDescription` |
| `PermissionTracking` | AppTrackingTransparency | `NSUserTrackingUsageDescription` |

> Khi add package vào Xcode, danh sách product sẽ hiện đầy đủ — **chỉ tick cái bạn dùng**. Product không tick sẽ không compile/link vào app.

## Cài đặt

```swift
.package(url: "https://github.com/theanvora/PermissionKit.git", from: "1.0.0")
```

Rồi chỉ thêm product cần dùng, ví dụ Snapfolio (PDF scan) chỉ cần camera + photos:

```swift
.target(name: "Snapfolio", dependencies: [
    .product(name: "PermissionCamera", package: "PermissionKit"),
    .product(name: "PermissionPhotos", package: "PermissionKit"),
])
```

## Dùng

### Async/await trực tiếp
```swift
import PermissionCamera

let status = await CameraPermission().request()
if status.isAuthorized { /* mở camera */ }
```

### SwiftUI – `PermissionState`
```swift
import PermissionCore
import PermissionCamera

struct ScanView: View {
    @StateObject private var camera = PermissionState(CameraPermission())

    var body: some View {
        Button("Bật camera") {
            Task { await camera.requestOrOpenSettings() }
        }
        .task { await camera.refresh() }
        .disabled(camera.isAuthorized)
    }
}
```

### SwiftUI – `PermissionButton` dựng sẵn
```swift
PermissionButton(PhotosPermission()) { status in
    Label("Thư viện ảnh", systemImage: status.isAuthorized ? "checkmark.circle" : "photo")
}
```

## Tự viết thêm quyền
Tạo target mới phụ thuộc `PermissionCore`, conform `Permission`, map về `PermissionStatus`.
```swift
public struct MyPermission: Permission {
    public init() {}
    public var title: String { "..." }
    public func status() async -> PermissionStatus { ... }
    public func request() async -> PermissionStatus { ... }
}
```

## Yêu cầu
- iOS 16+
- Swift 5.9+
