//
//  MusicLibraryPermission.swift
//  PermissionKit
//
//  Created by AnhPT on 02/07/2026.
//

import MediaPlayer
import PermissionCore

/// Apple Music / media library access. Declare `NSAppleMusicUsageDescription`.
public struct MusicLibraryPermission: Permission {
    public init() {}

    public var title: String { "Media Library" }

    public func status() async -> PermissionStatus {
        Self.map(MPMediaLibrary.authorizationStatus())
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = MPMediaLibrary.authorizationStatus()
        guard current == .notDetermined else { return Self.map(current) }
        return await withCheckedContinuation { continuation in
            MPMediaLibrary.requestAuthorization { status in
                continuation.resume(returning: Self.map(status))
            }
        }
    }

    static func map(_ status: MPMediaLibraryAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized:    return .authorized
        case .denied:        return .denied
        case .restricted:    return .restricted
        @unknown default:    return .denied
        }
    }
}
