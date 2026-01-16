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
        // Tento argument řekne StudySyncApp, aby zavolala funkci pro vložení dat
        app.launchArguments.append("--mock-data")
        app.launch()
        
        // Před každým testem dojdeme na obrazovku přidání
        navigateToNewCardScreen()
    }

    func navigateToNewCardScreen() {
        // 1. Přejít do knihovny
        // Zkoušíme ID 'LibraryTab', pokud není, tak texty
        let libraryTab = app.tabBars.buttons["LibraryTab"]
        if libraryTab.exists {
            libraryTab.tap()
        } else {
            let csTab = app.tabBars.buttons["Knihovna"]
            if csTab.exists { csTab.tap() } else { app.tabBars.buttons["Library"].tap() }
        }
        
        // 2. Otevřít balíček "Matematika" (Vytvořený v Mock datech)
        let packageRow = app.buttons["PackageRow_Matematika"]
        // Čekáme, než se mock data načtou a UI se překreslí
        XCTAssertTrue(packageRow.waitForExistence(timeout: 5), "Balíček Matematika nebyl nalezen. Funguje handleMockDataIfNeeded v StudySyncApp?")
        packageRow.tap()
        
        // 3. Otevřít skupinu "Testovací Skupina"
        // Zkoušíme najít řádek podle ID, fallback na text
        let groupRow = app.buttons["groupRow_Testovací Skupina"]
        if groupRow.waitForExistence(timeout: 2) {
            groupRow.tap()
        } else {
            app.staticTexts["Testovací Skupina"].tap()
        }
        
        // 4. Kliknout na tlačítko +
        let addCardBtn = app.buttons["AddCardButton"]
        XCTAssertTrue(addCardBtn.waitForExistence(timeout: 5), "Tlačítko + nebylo nalezeno")
        addCardBtn.tap()

        // 5. Ověření, že jsme na obrazovce
        let navBar = app.navigationBars["Nová karta"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5))
    }

    func testAddCardFlow() {
        let saveButton = app.buttons["saveButton"]
        
        // --- KLÍČOVÁ OPRAVA ---
        // Protože v AddCardView používáš `axis: .vertical`, SwiftUI z toho udělá UITextView.
        // XCTest to tedy vidí jako `textViews`, nikoliv `textFields`.
        let questionField = app.textViews["questionField"]
        let answerField = app.textViews["answerField"]

        // 1. Ověření: Tlačítko musí být na začátku šedé (neaktivní)
        XCTAssertFalse(saveButton.isEnabled, "Tlačítko Uložit by mělo být na začátku zakázané")

        // 2. Vyplnění otázky
        questionField.tap()
        questionField.typeText("Kolik je 5x5?")
        
        // Tlačítko stále neaktivní (chybí odpověď)
        XCTAssertFalse(saveButton.isEnabled)
        
        // 3. Vyplnění odpovědi
        answerField.tap()
        answerField.typeText("25")
        
        // 4. Triky pro aktualizaci UI:
        // Klikneme na navigační lištu, abychom schovali klávesnici a zrušili focus.
        // To donutí SwiftUI přepočítat stav formuláře.
        app.navigationBars["Nová karta"].tap()
        
        // 5. Čekání na aktivaci tlačítka
        // Změna barvy a stavu tlačítka není okamžitá, musíme vteřinku počkat.
        let isEnabledPredicate = NSPredicate(format: "isEnabled == true")
        expectation(for: isEnabledPredicate, evaluatedWith: saveButton, handler: nil)
        waitForExpectations(timeout: 2.0, handler: nil)
        
        // 6. Uložení
        saveButton.tap()
        
        // 7. Ověření výsledku
        // Měli bychom být zpět v seznamu a vidět novou kartu
        let newCardText = app.staticTexts["Kolik je 5x5?"]
        XCTAssertTrue(newCardText.waitForExistence(timeout: 2.0), "Nová karta se neobjevila v seznamu")
    }
}
