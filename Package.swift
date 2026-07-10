// swift-tools-version: 6.2
import PackageDescription

let concurrencyBaseline: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .defaultIsolation(nil),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
]

let package = Package(
    name: "PermissionKit",
    platforms: [
        .iOS("18.0")
    ],
    products: [
        .library(name: "PermissionCore",         targets: ["PermissionCore"]),
        .library(name: "PermissionCamera",       targets: ["PermissionCamera"]),
        .library(name: "PermissionMicrophone",   targets: ["PermissionMicrophone"]),
        .library(name: "PermissionPhotos",       targets: ["PermissionPhotos"]),
        .library(name: "PermissionLocation",     targets: ["PermissionLocation"]),
        .library(name: "PermissionNotification", targets: ["PermissionNotification"]),
        .library(name: "PermissionContacts",     targets: ["PermissionContacts"]),
        .library(name: "PermissionTracking",     targets: ["PermissionTracking"]),
        .library(name: "PermissionCalendar",     targets: ["PermissionCalendar"]),
        .library(name: "PermissionReminders",    targets: ["PermissionReminders"]),
        .library(name: "PermissionSpeech",       targets: ["PermissionSpeech"]),
        .library(name: "PermissionBluetooth",    targets: ["PermissionBluetooth"]),
        .library(name: "PermissionMotion",       targets: ["PermissionMotion"]),
        .library(name: "PermissionMusic",        targets: ["PermissionMusic"]),
        .library(name: "PermissionSiri",         targets: ["PermissionSiri"]),
        .library(name: "PermissionBiometric",    targets: ["PermissionBiometric"]),
        .library(name: "PermissionHealth",       targets: ["PermissionHealth"]),
    ],
    targets: [
        .target(name: "PermissionCore",         swiftSettings: concurrencyBaseline),
        .target(name: "PermissionCamera",       dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionMicrophone",   dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionPhotos",       dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionLocation",     dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionNotification", dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionContacts",     dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionTracking",     dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionCalendar",     dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionReminders",    dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionSpeech",       dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionBluetooth",    dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionMotion",       dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionMusic",        dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionSiri",         dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionBiometric",    dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .target(name: "PermissionHealth",       dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
        .testTarget(name: "PermissionKitTests",  dependencies: ["PermissionCore"], swiftSettings: concurrencyBaseline),
    ]
)
