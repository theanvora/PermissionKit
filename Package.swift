// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PermissionKit",
    platforms: [
        .iOS("26.0")
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
        .target(name: "PermissionCore"),
        .target(name: "PermissionCamera",       dependencies: ["PermissionCore"]),
        .target(name: "PermissionMicrophone",   dependencies: ["PermissionCore"]),
        .target(name: "PermissionPhotos",       dependencies: ["PermissionCore"]),
        .target(name: "PermissionLocation",     dependencies: ["PermissionCore"]),
        .target(name: "PermissionNotification", dependencies: ["PermissionCore"]),
        .target(name: "PermissionContacts",     dependencies: ["PermissionCore"]),
        .target(name: "PermissionTracking",     dependencies: ["PermissionCore"]),
        .target(name: "PermissionCalendar",     dependencies: ["PermissionCore"]),
        .target(name: "PermissionReminders",    dependencies: ["PermissionCore"]),
        .target(name: "PermissionSpeech",       dependencies: ["PermissionCore"]),
        .target(name: "PermissionBluetooth",    dependencies: ["PermissionCore"]),
        .target(name: "PermissionMotion",       dependencies: ["PermissionCore"]),
        .target(name: "PermissionMusic",        dependencies: ["PermissionCore"]),
        .target(name: "PermissionSiri",         dependencies: ["PermissionCore"]),
        .target(name: "PermissionBiometric",    dependencies: ["PermissionCore"]),
        .target(name: "PermissionHealth",       dependencies: ["PermissionCore"]),
        .testTarget(name: "PermissionKitTests",  dependencies: ["PermissionCore"]),
    ]
)
