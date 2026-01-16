//
//  PackagesListTest.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//
/*
import XCTest

final class PackagesListUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    // --- OPRAVENÁ NAVIGACE ---
    func navigateToLibrary() {
        // 1. Hledáme podle identifikátoru, který jsme dali do MainTabView
        let libraryTab = app.tabBars.buttons["LibraryTab"]
        
        // 2. Záložní řešení podle textu (kdyby ID selhalo)
        let libraryTextCZ = app.tabBars.buttons["Knihovna"]
        let libraryTextEN = app.tabBars.buttons["Library"]
        
        if libraryTab.exists {
            libraryTab.tap()
        } else if libraryTextCZ.exists {
            libraryTextCZ.tap()
        } else if libraryTextEN.exists {
            libraryTextEN.tap()
        } else {
            // Debug výpis pro zjištění, co test vidí
            print("⚠️ Viditelná tlačítka v TabBaru: \(app.tabBars.buttons.debugDescription)")
            XCTFail("Záložka Knihovna (LibraryTab) nebyla nalezena.")
        }
    }
    
    // --- TEST 1: Prázdný stav (Bez Mock Dat) ---
    func testEmptyStateOnFirstLaunch() {
        // Spouštíme BEZ argumentu --mock-data -> simulace čisté instalace
        app.launch()
        
        navigateToLibrary()
        
        // Hledáme text pro prázdný stav
        // Poznámka: Ujisti se, že v PackagesListView máš .accessibilityIdentifier("EmptyPackagesView")
        let emptyView = app.otherElements["EmptyPackagesView"]
        let emptyText = app.staticTexts["Žádné balíčky"]
        
        // Stačí, když najdeme jedno z toho
        let exists = emptyView.waitForExistence(timeout: 2) || emptyText.waitForExistence(timeout: 2)
        XCTAssertTrue(exists, "Měl by se zobrazit prázdný stav 'Žádné balíčky'")
    }
    
    // --- TEST 2: Vytvoření balíčku uživatelem (Bez Mock Dat) ---
    func testCreateNewPackageViaUI() {
        app.launch() // Čistý start
        navigateToLibrary()
        
        // 1. Kliknout na +
        let addButton = app.buttons["AddPackageButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Tlačítko + nebylo nalezeno")
        addButton.tap()
        
        // 2. Vyplnit formulář
        let nameField = app.textFields["packageNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2), "Pole pro název nebylo nalezeno")
        nameField.tap()
        nameField.typeText("Biologie")
        
        // 3. Vybrat barvu (Zelenou)
        // OPRAVA: Kruhy ve SwiftUI jsou často 'images'
        let greenColor = app.images["color_green"]
        if greenColor.exists {
            greenColor.tap()
        } else {
            app.buttons["color_green"].tap() // Fallback
        }
        
        // 4. Uložit
        let createButton = app.buttons["createPackageButton"]
        // Čekáme chvilku na validaci formuláře
        let isEnabled = NSPredicate(format: "isEnabled == true")
        expectation(for: isEnabled, evaluatedWith: createButton, handler: nil)
        waitForExpectations(timeout: 2.0, handler: nil)
        
        createButton.tap()
        
        // 5. Ověřit, že se objevil v seznamu
        // Čekáme na zmizení modálního okna a objevení řádku
        let newPackageRow = app.buttons["PackageRow_Biologie"]
        XCTAssertTrue(newPackageRow.waitForExistence(timeout: 3), "Nově vytvořený balíček 'Biologie' se neobjevil v seznamu")
    }
}*/
