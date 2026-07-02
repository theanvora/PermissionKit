//
//  PermissionState.swift
//  PermissionKit
//
//  Created by Anvora on 02/07/2026.
//

#if canImport(SwiftUI)
import SwiftUI
import Observation

/// SwiftUI-friendly box around a single permission: it publishes the live status
/// and forwards `request`/`refresh` so views can bind to it directly.
///
/// ```swift
/// @State private var camera = PermissionState(CameraPermission())
///
/// var body: some View {
///     Button("Enable camera") { Task { await camera.request() } }
///         .task { await camera.refresh() }
/// }
/// ```
@MainActor
@Observable
public final class PermissionState {
    public private(set) var status: PermissionStatus = .notDetermined

    @ObservationIgnored private let permission: Permission

    public init(_ permission: Permission) {
        self.permission = permission
    }

    public var isAuthorized: Bool { status.isAuthorized }

    /// Re-reads the current grant silently (no system prompt).
    public func refresh() async {
        status = await permission.status()
    }

    /// Triggers the prompt when needed and stores the resulting `status`.
    @discardableResult
    public func request() async -> PermissionStatus {
        status = await permission.request()
        return status
    }

    /// Ask on first use; bounce to Settings if the user has already said no.
    public func requestOrOpenSettings() async {
        let result = await request()
        if result.shouldOpenSettings {
            PermissionSettings.open()
        }
    }
}
#endif
