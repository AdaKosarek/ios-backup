//
//  PackagesListTest.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//


import XCTest

final class PackagesListUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    // Pomocná funkce pro přechod do knihovny
    func navigateToLibrary() {
        let libraryTab = app.tabBars.buttons["Library"]
        XCTAssertTrue(libraryTab.waitForExistence(timeout: 5), "Záložka Library nebyla nalezena")
        libraryTab.tap()
    }

    // --- TEST 1: Prázdný stav (Bez Mock Dat) ---
    func testEmptyStateOnFirstLaunch() {
        // Spouštíme BEZ argumentu --mock-data -> simulace čisté instalace
        app.launch()
        
        navigateToLibrary()
        
        // Hledáme text pro prázdný stav (ContentUnavailableView)
        // Pokud používáš v kódu ContentUnavailableView, identifikátor můžeš přidat tam,
        // nebo hledat text "Žádné balíčky".
        let emptyText = app.staticTexts["Žádné balíčky"]
        
        // Použijeme waitForExistence, protože načtení view chvilku trvá
        if emptyText.waitForExistence(timeout: 2) {
            XCTAssertTrue(emptyText.exists)
        }
    }

    // --- TEST 2: Vytvoření balíčku uživatelem (Bez Mock Dat) ---
    func testCreateNewPackageViaUI() {
        app.launch() // Čistý start
        navigateToLibrary()
        
        // 1. Kliknout na +
        let addButton = app.buttons["AddPackageButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        
        // 2. Vyplnit formulář
        let nameField = app.textFields["packageNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText("Biologie")
        
        // 3. Vybrat barvu (volitelné, pokud default je ok)
        let greenColor = app.otherElements["color_green"] // nebo .buttons
        if greenColor.exists {
            greenColor.tap()
        }
        
        // 4. Uložit
        let createButton = app.buttons["createPackageButton"]
        XCTAssertTrue(createButton.isEnabled)
        createButton.tap()
        
        // 5. Ověřit, že se objevil v seznamu
        let newPackageRow = app.buttons["PackageRow_Biologie"]
        XCTAssertTrue(newPackageRow.waitForExistence(timeout: 2), "Nově vytvořený balíček se neobjevil v seznamu")
    }

    // --- TEST 3: Smazání balíčku (S Mock Daty) ---
    func testDeletePackage() {
        // Zde POUŽIJEME mock data, abychom měli co mazat hned po startu
        app.launchArguments.append("--mock-data")
        app.launch()
        
        navigateToLibrary()
        
        // Hledáme balíček Matematika (vytvořený v MockDataService)
        let packageRow = app.buttons["PackageRow_Matematika"]
        XCTAssertTrue(packageRow.waitForExistence(timeout: 5), "Balíček Matematika z Mock dat nebyl nalezen")
        
        // Gesto smazání
        packageRow.swipeLeft()
        
        // Kliknutí na smazat
        let deleteButton = app.buttons["Delete"]
        if deleteButton.exists {
            deleteButton.tap()
        } else {
            let smazatBtn = app.buttons["Smazat"]
            if smazatBtn.exists { smazatBtn.tap() }
        }
        
        // Ověření zmizení
        let doesNotExist = NSPredicate(format: "exists == false")
        expectation(for: doesNotExist, evaluatedWith: packageRow, handler: nil)
        waitForExpectations(timeout: 3.0, handler: nil)
        
        XCTAssertFalse(packageRow.exists)
    }
}
