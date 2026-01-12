//
//  PackageDetailTest.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

import XCTest

final class PackageDetailUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Zastavíme test při první chybě
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Spustíme aplikaci s čistými Mock daty (vytvoří se balíček Matematika)
        app.launchArguments.append("--mock-data")
        app.launch()
        
        // --- NAVIGACE ---
        // 1. Přepneme se na Library tab
        app.tabBars.buttons["Library"].tap()
        
        // 2. Klikneme na balíček Matematika, abychom se dostali do PackageDetailView
        let packageRow = app.buttons["PackageRow_Matematika"]
        XCTAssertTrue(packageRow.waitForExistence(timeout: 5), "Balíček Matematika nebyl v seznamu nalezen.")
        packageRow.tap()
    }

    func testAddNewGroupViaAlert() {
        let addButton = app.buttons["addGroupButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        
        // 1. Najdeme alert
        let alert = app.alerts["Nová skupina"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert se neobjevil")
        
        // 2. Najdeme textové pole (použijeme firstMatch pro jistotu)
        let textField = alert.textFields.firstMatch
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText("Geometrie")
        
        // 3. KLÍČOVÁ OPRAVA: Kliknutí na tlačítko "Vytvořit"
        // Použijeme .buttons["Vytvořit"].firstMatch, aby Xcode neřešil duplicity
        let confirmButton = alert.buttons["Vytvořit"].firstMatch
        
        XCTAssertTrue(confirmButton.exists, "Tlačítko Vytvořit nebylo nalezeno")
        confirmButton.tap()
        
        // 4. Ověření výsledku
        let newGroup = app.staticTexts["Geometrie"]
        XCTAssertTrue(newGroup.waitForExistence(timeout: 5), "Nová skupina se v seznamu neobjevila")
    }

    func testPlayButtonAvailability() {
        // Tlačítko Play by mělo existovat
        let playButton = app.buttons["playSessionButton"]
        XCTAssertTrue(playButton.exists)
        
        // V našem Mocku nemá balíček Matematika hned po startu žádné karty,
        // takže kliknutí by nemělo otevřít SessionView.
        playButton.tap()
        
        // Ověříme, že se neotevřela obrazovka s nadpisem "Učení" (pokud ho v SessionView máš)
        XCTAssertFalse(app.navigationBars["Učení"].exists)
    }
}
