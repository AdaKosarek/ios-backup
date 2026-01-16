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
        continueAfterFailure = false
        app = XCUIApplication()
        
        // VŽDY použijeme Mock data, protože testujeme detail existujícího balíčku
        app.launchArguments.append("--mock-data")
        app.launch()
        
        navigateToDetail()
    }
    
    func navigateToDetail() {
        // 1. Library
        let libraryTab = app.tabBars.buttons["Library"]
        XCTAssertTrue(libraryTab.waitForExistence(timeout: 5))
        libraryTab.tap()
        
        // 2. Balíček Matematika
        let packageRow = app.buttons["PackageRow_Matematika"]
        XCTAssertTrue(packageRow.waitForExistence(timeout: 5))
        packageRow.tap()
    }

    func testAddNewGroupViaAlert() {
        // Klik na +
        let addButton = app.buttons["addGroupButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        
        // Alert
        let alert = app.alerts["Nová skupina"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        
        // Vyplnění
        let textField = alert.textFields.firstMatch
        textField.tap()
        textField.typeText("Geometrie")
        
        // Potvrzení
        let confirmButton = alert.buttons["Vytvořit"].firstMatch
        confirmButton.tap()
        
        // Ověření - hledáme tlačítko/řádek s názvem skupiny
        // Poznámka: V PackageDetailView máme NavigationLink, což se v testech často tváří jako Button
        let newGroup = app.buttons["groupRow_Geometrie"]
        
        // Fallback hledání (pokud ID nezafunguje hned)
        if !newGroup.waitForExistence(timeout: 2) {
             XCTAssertTrue(app.staticTexts["Geometrie"].exists)
        } else {
             XCTAssertTrue(newGroup.exists)
        }
    }

    func testPlayButtonOpensSession() {
        // V naší nové MockDataService.addMockDataForUITests() jsme přidali i KARTU.
        // Tím pádem tlačítko Play MUSÍ být aktivní a funkční.
        
        let playButton = app.buttons["playSessionButton"]
        XCTAssertTrue(playButton.waitForExistence(timeout: 2))
        XCTAssertTrue(playButton.isEnabled, "Tlačítko Play by mělo být aktivní, protože mock data obsahují karty.")
        
        playButton.tap()
        
        // Ověříme, že se otevřelo SessionView
        // Můžeme hledat nav bar "Studium" nebo kartu
        let studyNavBar = app.navigationBars["Studium"]
        XCTAssertTrue(studyNavBar.waitForExistence(timeout: 2), "Po kliknutí na Play se neotevřelo okno Studium")
        
        // Ověříme, že vidíme mockovanou kartu
        let cardText = app.staticTexts["Fixní Otázka"]
        XCTAssertTrue(cardText.exists)
    }
}
