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
        // Použijeme Mock data pro čistý start
        app.launchArguments.append("--mock-data")
        app.launch()
        
        navigateToEditPackageScreen()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    // --- OPRAVENÁ NAVIGACE ---
    func navigateToEditPackageScreen() {
        // 1. Jdeme do Library
        let libraryTab = app.tabBars.buttons["Library"]
        XCTAssertTrue(libraryTab.waitForExistence(timeout: 5), "Záložka Library nebyla nalezena")
        libraryTab.tap()
        
        // 2. Klikneme na tlačítko pro přidání balíčku
        // Musíš mít v aplikaci identifikátor "AddPackageButton" (viz níže)
        let addButton = app.buttons["AddPackageButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Tlačítko + (AddPackageButton) nebylo nalezeno")
        addButton.tap()
        
        // 3. Ověříme, že jsme na obrazovce
        let navBar = app.navigationBars["Nový balíček"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5), "Formulář 'Nový balíček' se neotevřel")
    }

    // Test 1: Validace tlačítka (Disabled/Enabled)
    func testCreateButtonDisabledIdeally() {
        let createButton = app.buttons["createPackageButton"]
        let nameField = app.textFields["packageNameField"]
        
        // Na začátku musí být vypnuté
        XCTAssertFalse(createButton.isEnabled, "Tlačítko Vytvořit má být na začátku neaktivní.")
        
        // Zadáme text
        nameField.tap()
        nameField.typeText("Fyzika")
        
        // Počkáme chvíli na změnu stavu
        let isEnabled = NSPredicate(format: "isEnabled == true")
        expectation(for: isEnabled, evaluatedWith: createButton, handler: nil)
        waitForExpectations(timeout: 2.0, handler: nil)
        
        XCTAssertTrue(createButton.isEnabled, "Tlačítko se neaktivovalo po zadání názvu.")
    }

    // Test 2: Vytvoření s barvou
    func testCreatePackageWithColor() {
        let nameField = app.textFields["packageNameField"]
        let createButton = app.buttons["createPackageButton"]
        
        // 1. Zadat název
        nameField.tap()
        nameField.typeText("Angličtina")
        
        // 2. Vybrat červenou barvu
        // Hledáme prvek s ID "color_red"
        let redColorCircle = app.otherElements["color_red"]
        // Pokud ho nemůže najít jako otherElement, zkusíme button (pokud je to tlačítko)
        if !redColorCircle.exists {
             app.buttons["color_red"].tap()
        } else {
             redColorCircle.tap()
        }
        
        // 3. Uložit
        XCTAssertTrue(createButton.isEnabled)
        createButton.tap()
        
        // 4. Ověření zavření
        let navBar = app.navigationBars["Nový balíček"]
        let doesNotExist = NSPredicate(format: "exists == false")
        
        expectation(for: doesNotExist, evaluatedWith: navBar, handler: nil)
        waitForExpectations(timeout: 2.0, handler: nil)
        
        // Bonus: Ověření, že je nový balíček v seznamu
        XCTAssertTrue(app.staticTexts["Angličtina"].waitForExistence(timeout: 2))
    }
}
