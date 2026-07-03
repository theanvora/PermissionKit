//
//  CalendarPermission.swift
//  PermissionKit
//
//  Created by AnhPT on 02/07/2026.
//

import EventKit
import PermissionCore

/// Calendar (events) access. Declare `NSCalendarsUsageDescription`
/// (and `NSCalendarsWriteOnlyAccessUsageDescription` for `.writeOnly`).
public struct CalendarPermission: Permission {
    public enum Access: Sendable {
        case full
        case writeOnly
    }

    private let access: Access

    public init(access: Access = .full) {
        self.access = access
    }

    public var title: String { "Calendar" }

    public func status() async -> PermissionStatus {
        Self.map(EKEventStore.authorizationStatus(for: .event))
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = EKEventStore.authorizationStatus(for: .event)
        guard current == .notDetermined else { return Self.map(current) }

        let store = EKEventStore()
        do {
            let granted: Bool
            switch access {
            case .full:      granted = try await store.requestFullAccessToEvents()
            case .writeOnly: granted = try await store.requestWriteOnlyAccessToEvents()
            }
            return granted ? (access == .writeOnly ? .limited : .authorized) : .denied
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
