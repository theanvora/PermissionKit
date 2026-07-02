//
//  RemindersPermission.swift
//  PermissionKit
//
//  Created by Anvora on 02/07/2026.
//

import EventKit
import PermissionCore

/// Reminders access. Declare `NSRemindersUsageDescription`
/// (iOS 17+ uses `NSRemindersFullAccessUsageDescription`).
public struct RemindersPermission: Permission {
    public init() {}

    public var title: String { "Reminders" }

    public func status() async -> PermissionStatus {
        Self.map(EKEventStore.authorizationStatus(for: .reminder))
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = EKEventStore.authorizationStatus(for: .reminder)
        guard current == .notDetermined else { return Self.map(current) }

        let store = EKEventStore()
        do {
            let granted = try await store.requestFullAccessToReminders()
            return granted ? .authorized : .denied
        } catch {
            return .denied
        }
    }

    static func map(_ status: EKAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .restricted:    return .restricted
        case .denied:        return .denied
        case .authorized:    return .authorized
        case .writeOnly:     return .limited
        @unknown default:    return .denied
        }
    }
}
