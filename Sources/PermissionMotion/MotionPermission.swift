//
//  MotionPermission.swift
//  PermissionKit
//
//  Created by AnhPT on 02/07/2026.
//

import CoreMotion
import PermissionCore

/// Motion & Fitness (activity / step counting). Declare `NSMotionUsageDescription`.
///
/// CoreMotion has no dedicated request call — issuing a throwaway activity query
/// is what surfaces the system prompt.
public struct MotionPermission: Permission {
    public init() {}

    public var title: String { "Motion & Fitness" }

    public func status() async -> PermissionStatus {
        Self.map(CMMotionActivityManager.authorizationStatus())
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = CMMotionActivityManager.authorizationStatus()
        guard current == .notDetermined else { return Self.map(current) }

        let manager = CMMotionActivityManager()
        let now = Date()
        return await withCheckedContinuation { continuation in
            manager.queryActivityStarting(from: now, to: now, to: .main) { _, _ in
                _ = manager   // hold the manager alive until the callback fires
                continuation.resume(returning: Self.map(CMMotionActivityManager.authorizationStatus()))
            }
        }
    }

    static func map(_ status: CMAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized:    return .authorized
        case .denied:        return .denied
        case .restricted:    return .restricted
        @unknown default:    return .denied
        }
    }
}
