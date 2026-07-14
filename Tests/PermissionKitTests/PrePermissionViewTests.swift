//
//  PrePermissionViewTests.swift
//  PermissionKit
//
//  Created by AnhPT on 14/07/2026.
//

import XCTest
import SwiftUI
@testable import PermissionCore

private struct StubPermission: Permission {
    var title: String { "Stub" }
    func status() async -> PermissionStatus { .notDetermined }
    func request() async -> PermissionStatus { .authorized }
}

@MainActor
final class PrePermissionViewTests: XCTestCase {
    func testConstructsWithPermission() {
        var decided: PermissionStatus?
        _ = PrePermissionView(StubPermission(),
                              systemImage: "camera.fill",
                              headline: "Scan documents",
                              message: "We use the camera to capture your documents.",
                              onDecision: { decided = $0 },
                              onSkip: {})
        XCTAssertNil(decided)   // no interaction yet
    }
}
