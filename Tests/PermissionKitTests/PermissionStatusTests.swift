//
//  PermissionStatusTests.swift
//  PermissionKit
//
//  Created by AnhPT on 02/07/2026.
//

import XCTest
@testable import PermissionCore

final class PermissionStatusTests: XCTestCase {
    func testIsAuthorized() {
        XCTAssertTrue(PermissionStatus.authorized.isAuthorized)
        XCTAssertTrue(PermissionStatus.limited.isAuthorized)
        XCTAssertTrue(PermissionStatus.provisional.isAuthorized)
        XCTAssertFalse(PermissionStatus.notDetermined.isAuthorized)
        XCTAssertFalse(PermissionStatus.denied.isAuthorized)
        XCTAssertFalse(PermissionStatus.restricted.isAuthorized)
    }

    func testShouldOpenSettings() {
        XCTAssertTrue(PermissionStatus.denied.shouldOpenSettings)
        XCTAssertTrue(PermissionStatus.restricted.shouldOpenSettings)
        XCTAssertFalse(PermissionStatus.authorized.shouldOpenSettings)
        XCTAssertFalse(PermissionStatus.notDetermined.shouldOpenSettings)
    }
}
