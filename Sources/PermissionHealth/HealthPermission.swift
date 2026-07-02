//
//  HealthPermission.swift
//  PermissionKit
//
//  Created by Anvora on 02/07/2026.
//

import HealthKit
import PermissionCore

/// HealthKit access. Needs the **HealthKit capability/entitlement** plus
/// `NSHealthShareUsageDescription` / `NSHealthUpdateUsageDescription`.
///
/// Pass the exact types you read/write. Note Apple deliberately hides *read*
/// authorization for privacy, so `status()` can only reflect *share* access.
public struct HealthPermission: Permission {
    private let read: Set<HKObjectType>
    private let share: Set<HKSampleType>

    public init(read: Set<HKObjectType> = [], share: Set<HKSampleType> = []) {
        self.read = read
        self.share = share
    }

    public var title: String { "Health" }

    public func status() async -> PermissionStatus {
        guard HKHealthStore.isHealthDataAvailable() else { return .restricted }
        guard let probe = share.first ?? (read.first as? HKSampleType) else { return .notDetermined }
        return Self.map(HKHealthStore().authorizationStatus(for: probe))
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        guard HKHealthStore.isHealthDataAvailable() else { return .restricted }
        do {
            try await HKHealthStore().requestAuthorization(toShare: share, read: read)
            return await status()
        } catch {
            return .denied
        }
    }

    static func map(_ status: HKAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined:     return .notDetermined
        case .sharingAuthorized: return .authorized
        case .sharingDenied:     return .denied
        @unknown default:        return .denied
        }
    }
}
