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
        app.launchArguments.append("--mock-data")
        app.launch()
        
        // Spustíme navigaci, která je odolná vůči chybějícím datům
        navigateToNewCardScreen()
    }

    func navigateToNewCardScreen() {
        // 1. Přejít do knihovny
        let libraryTab = app.tabBars.buttons["Library"]
        XCTAssertTrue(libraryTab.waitForExistence(timeout: 5), "Záložka Library nebyla nalezena")
        libraryTab.tap()
        
        // 2. Otevřít balíček Matematika
        let packageRow = app.buttons["PackageRow_Matematika"]
        XCTAssertTrue(packageRow.waitForExistence(timeout: 5), "Balíček Matematika nebyl nalezen (funguje UITestLauncher?)")
        packageRow.tap()
        
        // 3. Otevřít skupinu (Defenzivní strategie)
        // Zkusíme najít skupinu "Obecné". Pokud tam není, vytvoříme ji.
        let groupRow = app.staticTexts["Obecné"]
        
        if !groupRow.waitForExistence(timeout: 2) {
            print("Skupina Obecné nenalezena, vytvářím ji ručně...")
            
            // Klikni na + pro skupinu
            let addGroupBtn = app.buttons["addGroupButton"]
            XCTAssertTrue(addGroupBtn.exists, "Tlačítko pro přidání skupiny chybí")
            addGroupBtn.tap()
            
            // Vyplň alert
            let alert = app.alerts["Nová skupina"]
            XCTAssertTrue(alert.waitForExistence(timeout: 2))
            
            let textField = alert.textFields.firstMatch
            textField.typeText("Obecné")
            
            let createButton = alert.buttons["Vytvořit"].firstMatch
            createButton.tap()
        }
        
        // Teď už tam skupina na 100% musí být
        XCTAssertTrue(groupRow.waitForExistence(timeout: 5), "Skupina se nepodařila otevřít ani po vytvoření")
        groupRow.tap()
        
        // 4. Kliknout na + pro přidání karty (v CardListView)
        let addCardBtn = app.buttons["AddCardButton"] // Ujisti se, že máš toto ID v CardListView v toolbaru!
        if !addCardBtn.exists {
             // Fallback: Někdy je tlačítko jen jako "Add", "Plus" nebo image
             // Zkusíme najít první tlačítko v toolbaru, pokud ID selže
             app.buttons["Add"].firstMatch.tap()
        } else {
             addCardBtn.tap()
        }

        // 5. Ověření, že jsme na obrazovce
        let navBar = app.navigationBars["Nová karta"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5), "Nepodařilo se otevřít obrazovku Nová karta")
    }

    func testSaveButtonIsDisabledInitially() {
            let saveButton = app.buttons["saveButton"]
            
            // --- OPRAVA PRO axis: .vertical ---
            // Kvůli axis: .vertical je Xcode zmatený, jestli je to TextView nebo TextField.
            // Zkusíme najít TextView, a když tam není, zkusíme TextField.
            
            var questionField = app.textViews["questionField"]
            if !questionField.exists {
                questionField = app.textFields["questionField"]
            }
            
            var answerField = app.textViews["answerField"]
            if !answerField.exists {
                answerField = app.textFields["answerField"]
            }

            // 1. Start: Neaktivní
            XCTAssertFalse(saveButton.isEnabled, "Tlačítko má být na začátku šedé")

            // 2. Vyplnění otázky
            questionField.tap()
            questionField.typeText("Test Otázka")
            
            // 3. Vyplnění odpovědi
            answerField.tap()
            answerField.typeText("Test Odpověď")
            
            // 4. Čekání na aktivaci tlačítka
            let isEnabledPredicate = NSPredicate(format: "isEnabled == true")
            expectation(for: isEnabledPredicate, evaluatedWith: saveButton, handler: nil)
            waitForExpectations(timeout: 3.0, handler: nil)
            
            XCTAssertTrue(saveButton.isEnabled, "Tlačítko se neaktivovalo po vyplnění")
        }
}
