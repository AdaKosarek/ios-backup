//
//  PackagesListTest.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

import XCTest

final class PackagesListViewUITests: BaseUITestCase {
    
    func testPackagesTabOpens() {
        let packagesTab = app.buttons["tab_packages"]
        XCTAssertTrue(packagesTab.waitForExistence(timeout: 5))
        packagesTab.tap()

        let addButton = app.buttons["addPackageButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
    }

    func testAddPackageButtonExists() {
        app.buttons["tab_packages"].tap()

        let addButton = app.buttons["addPackageButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
    }

    func testAddPackageSheetOpens() {
        app.buttons["tab_packages"].tap()

        let addButton = app.buttons["addPackageButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
    }

    func testPackagesListExists() {
        app.buttons["tab_packages"].tap()

        let list = app.otherElements["packagesList"]
        XCTAssertTrue(
            list.waitForExistence(timeout: 5),
            "Packages list se nevykreslil"
        )
    }
}

