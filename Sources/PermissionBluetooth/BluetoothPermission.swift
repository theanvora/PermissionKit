//
//  BluetoothPermission.swift
//  PermissionKit
//
//  Created by AnhPT on 02/07/2026.
//

import CoreBluetooth
import PermissionCore

/// Bluetooth access. Declare `NSBluetoothAlwaysUsageDescription`.
///
/// There is no async system API, so the first `request()` spins up a transient
/// `CBCentralManager` and waits for the delegate to report the decision.
/// `@unchecked Sendable`: the transient `CBCentralManager` and its delegate callbacks run on the
/// main run loop (created here with `queue: nil`), so the mutable `central`/`continuation` state is
/// only touched there. `@MainActor` can't be used instead because `Permission` is a nonisolated
/// `Sendable` protocol and a main-actor-isolated conformance cannot satisfy it.
public final class BluetoothPermission: NSObject, Permission, @unchecked Sendable {
    private var central: CBCentralManager?
    private var continuation: CheckedContinuation<PermissionStatus, Never>?

    public override init() { super.init() }

    public var title: String { "Bluetooth" }

    public func status() async -> PermissionStatus {
        Self.map(CBCentralManager.authorization)
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = CBCentralManager.authorization
        guard current == .notDetermined else { return Self.map(current) }
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            // Suppress the system "power off" alert; we only want the auth prompt.
            central = CBCentralManager(
                delegate: self,
                queue: nil,
                options: [CBCentralManagerOptionShowPowerAlertKey: false]
            )
        }
    }

    static func map(_ status: CBManagerAuthorization) -> PermissionStatus {
        switch status {
        case .notDetermined:  return .notDetermined
        case .allowedAlways:  return .authorized
        case .denied:         return .denied
        case .restricted:     return .restricted
        @unknown default:     return .denied
        }
    }
}

extension BluetoothPermission: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let auth = CBCentralManager.authorization
        guard auth != .notDetermined, let continuation else { return }
        self.continuation = nil
        self.central = nil
        continuation.resume(returning: Self.map(auth))
    }
}
