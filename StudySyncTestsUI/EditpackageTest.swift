//
//  EditpackageTest.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

import XCTest

final class EditPackageUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--mock-data")
        app.launch()
        
        navigateToEditPackageScreen()
    }

    func navigateToEditPackageScreen() {
        let libraryTab = app.tabBars.buttons["Library"]
        XCTAssertTrue(libraryTab.waitForExistence(timeout: 5))
        libraryTab.tap()
        
        let addButton = app.buttons["AddPackageButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        
        let navBar = app.navigationBars["Nový balíček"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5))
    }

    func testCreatePackageWithColor() {
        let nameField = app.textFields["packageNameField"]
        let createButton = app.buttons["createPackageButton"]
        
        // 1. Zadat název
        nameField.tap()
        nameField.typeText("Fyzika")
        
        // 2. Vybrat červenou barvu (hledáme podle ID color_red)
        let redColor = app.otherElements["color_red"]
        if redColor.exists {
            redColor.tap()
        }
        
        // 3. Uložit
        XCTAssertTrue(createButton.isEnabled)
        createButton.tap()
        
        // 4. Ověření zavření modálního okna
        let navBar = app.navigationBars["Nový balíček"]
        let doesNotExist = NSPredicate(format: "exists == false")
        expectation(for: doesNotExist, evaluatedWith: navBar, handler: nil)
        waitForExpectations(timeout: 2.0, handler: nil)
        
        // 5. Ověření v seznamu
        // Protože používáme MockService, po uložení se data přidají do pole v paměti
        // a PackagesListViewModel by se měl aktualizovat.
        let newPackage = app.staticTexts["Fyzika"]
        XCTAssertTrue(newPackage.waitForExistence(timeout: 2))
    }
}
