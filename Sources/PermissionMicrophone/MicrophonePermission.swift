//
//  MicrophonePermission.swift
//  PermissionKit
//
//  Created by Anvora on 02/07/2026.
//

import AVFoundation
import PermissionCore

/// Audio-capture access. Remember to declare `NSMicrophoneUsageDescription`.
public struct MicrophonePermission: Permission {
    public init() {}

    public var title: String { "Microphone" }

    public func status() async -> PermissionStatus {
        Self.map(AVCaptureDevice.authorizationStatus(for: .audio))
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = AVCaptureDevice.authorizationStatus(for: .audio)
        guard current == .notDetermined else { return Self.map(current) }
        let granted = await AVCaptureDevice.requestAccess(for: .audio)
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
