//
//  LocationPermission.swift
//  PermissionKit
//
//  Created by Anvora on 02/07/2026.
//

import CoreLocation
import PermissionCore

/// Location access. Declare `NSLocationWhenInUseUsageDescription`, plus
/// `NSLocationAlwaysAndWhenInUseUsageDescription` if you ever pass `.always`.
public final class LocationPermission: NSObject, Permission, @unchecked Sendable {
    public enum Kind: Sendable {
        case whenInUse
        case always
    }

    private let kind: Kind
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<PermissionStatus, Never>?

    public init(kind: Kind = .whenInUse) {
        self.kind = kind
        super.init()
        manager.delegate = self
    }

    public var title: String { "Location" }

    public func status() async -> PermissionStatus {
        Self.map(manager.authorizationStatus)
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = manager.authorizationStatus
        guard current == .notDetermined else { return Self.map(current) }

        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            switch kind {
            case .whenInUse: manager.requestWhenInUseAuthorization()
            case .always:    manager.requestAlwaysAuthorization()
            }
        }
    }

    static func map(_ status: CLAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined:                   return .notDetermined
        case .authorizedAlways:                return .authorized
        case .authorizedWhenInUse:             return .authorized
        case .denied:                          return .denied
        case .restricted:                      return .restricted
        @unknown default:                      return .denied
        }
    }
}

extension LocationPermission: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // This fires once right after the delegate is wired up (still .notDetermined) — ignore that pass.
        guard manager.authorizationStatus != .notDetermined,
              let continuation else { return }
        self.continuation = nil
        continuation.resume(returning: Self.map(manager.authorizationStatus))
    }
}
