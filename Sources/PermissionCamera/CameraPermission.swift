//
//  CameraPermission.swift
//  PermissionKit
//
//  Created by AnhPT on 02/07/2026.
//

import AVFoundation
import PermissionCore

/// Video-capture access. Remember to declare `NSCameraUsageDescription`.
public struct CameraPermission: Permission {
    public init() {}

    public var title: String { "Camera" }

    public func status() async -> PermissionStatus {
        Self.map(AVCaptureDevice.authorizationStatus(for: .video))
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = AVCaptureDevice.authorizationStatus(for: .video)
        guard current == .notDetermined else { return Self.map(current) }
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        return granted ? .authorized : .denied
    }

    static func map(_ status: AVAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized:    return .authorized
        case .denied:        return .denied
        case .restricted:    return .restricted
        @unknown default:    return .denied
        }
    }
}
