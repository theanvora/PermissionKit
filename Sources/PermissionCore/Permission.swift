//
//  Permission.swift
//  PermissionKit
//
//  Created by Anvora on 02/07/2026.
//

import Foundation

/// One uniform surface every concrete permission adopts. Each lives in its own
/// target so it pulls in only its matching system framework (e.g. Camera ⇒ AVFoundation).
public protocol Permission: Sendable {
    /// Human-readable name, handy for UI labels and logging.
    var title: String { get }

    /// Peek at the current grant without ever triggering a system dialog.
    func status() async -> PermissionStatus

    /// Ask for access. Once the user has already decided, this is a no-op that
    /// simply echoes the existing status — the prompt never reappears.
    @discardableResult
    func request() async -> PermissionStatus
}
