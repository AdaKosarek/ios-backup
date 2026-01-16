//
//  AddCardTest.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

import XCTest

final class AddCardUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--mock-data") // Aktivuje náš Mock v App
        app.launch()
        
        navigateToNewCardScreen()
    }

    func navigateToNewCardScreen() {
            // 1. Přejít do knihovny
            let libraryTab = app.tabBars.buttons["Library"]
            XCTAssertTrue(libraryTab.waitForExistence(timeout: 5))
            libraryTab.tap()
            
            // 2. Otevřít balíček Matematika
            let packageRow = app.buttons["PackageRow_Matematika"]
            XCTAssertTrue(packageRow.waitForExistence(timeout: 5))
            packageRow.tap()
            
            // 3. Otevřít skupinu (z MockDataService se jmenuje "Testovací Skupina")
            // Zkusíme najít tlačítko/řádek
            let groupRow = app.buttons["groupRow_Testovací Skupina"]
            
            if groupRow.exists {
                 groupRow.tap()
            } else {
                 // Fallback: Zkusíme kliknout na text
                 app.staticTexts["Testovací Skupina"].tap()
            }
            
            // 4. Kliknout na + (nyní už má ID AddCardButton)
            let addCardBtn = app.buttons["AddCardButton"]
            XCTAssertTrue(addCardBtn.waitForExistence(timeout: 5), "Tlačítko pro přidání karty nebylo nalezeno")
            addCardBtn.tap()

            // 5. Ověření
            let navBar = app.navigationBars["Nová karta"]
            XCTAssertTrue(navBar.waitForExistence(timeout: 5), "Nepodařilo se otevřít obrazovku Nová karta")
        }

    func testSaveButtonIsDisabledInitially() {
        let saveButton = app.buttons["saveButton"]
        let questionField = app.textFields["questionField"] // V AddCardView jsme použili TextField
        let answerField = app.textFields["answerField"]

        XCTAssertFalse(saveButton.isEnabled, "Tlačítko má být na začátku šedé")

        questionField.tap()
        questionField.typeText("Test Q")
        
        answerField.tap()
        answerField.typeText("Test A")
        
        // Klikni jinam, aby se ztratil focus (někdy pomůže pro aktualizaci stavu tlačítka)
        app.navigationBars["Nová karta"].tap()
        
        XCTAssertTrue(saveButton.isEnabled, "Tlačítko se neaktivovalo po vyplnění")
    }
}
