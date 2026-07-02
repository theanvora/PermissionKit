//
//  PermissionStatus.swift
//  PermissionKit
//
//  Created by Anvora on 02/07/2026.
//

import Foundation

/// A single, framework-agnostic vocabulary that every permission collapses into.
public enum PermissionStatus: String, Sendable, Equatable, CaseIterable {
    /// No decision yet — the system prompt has never been shown.
    case notDetermined
    /// Full access granted.
    case authorized
    /// Partial access (e.g. a subset of photos or contacts).
    case limited
    /// Silently granted without a prompt (notifications only).
    case provisional
    /// Explicitly refused by the user.
    case denied
    /// Locked down by the OS (Screen Time, MDM…); the user cannot flip it.
    case restricted

    /// Whether the feature can actually be used right now.
    public var isAuthorized: Bool {
        switch self {
        case .authorized, .limited, .provisional: return true
        case .notDetermined, .denied, .restricted: return false
        }
    }

    /// True when the only way forward is the system Settings app.
    public var shouldOpenSettings: Bool {
        self == .denied || self == .restricted
    }
}
