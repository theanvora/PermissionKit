// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PermissionKit",
    platforms: [
        .iOS(.v16)
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
        .testTarget(name: "PermissionKitTests",  dependencies: ["PermissionCore"]),
    ]
)
