//
//  EditPackageUITests.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//
/*
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
            // 1. Zkusíme najít záložku Knihovna (více způsoby)
            let libraryTabID = app.tabBars.buttons["LibraryTab"] // Podle ID v tabbaru
            let libraryTabButton = app.buttons["LibraryTab"]     // Jako obecné tlačítko
            let libraryTabText = app.buttons["Knihovna"]         // Podle českého textu
            let libraryTabTextEN = app.buttons["Library"]        // Podle anglického textu

            if libraryTabID.exists {
                libraryTabID.tap()
            } else if libraryTabButton.exists {
                libraryTabButton.tap()
            } else if libraryTabText.exists {
                libraryTabText.tap()
            } else if libraryTabTextEN.exists {
                libraryTabTextEN.tap()
            } else {
                // Pokud nic nenajdeme, vypíšeme, co aplikace vidí, a failneme test
                print("⚠️ DEBUG: Viditelná tlačítka: \(app.buttons.debugDescription)")
                XCTFail("Záložka Knihovna nebyla nalezena (ani podle ID 'LibraryTab', ani podle textu)")
                return
            }
            
            // 2. Kliknutí na + (Přidat balíček)
            let addButton = app.buttons["AddPackageButton"]
            // Pokud tlačítko neexistuje, může to být proto, že jsme na špatné obrazovce, nebo se UI ještě nenačetlo
            if !addButton.waitForExistence(timeout: 5) {
                XCTFail("Tlačítko '+' (AddPackageButton) nebylo nalezeno. Jsme na správné obrazovce?")
            }
            addButton.tap()
            
            // 3. Ověření nadpisu
            let navBar = app.navigationBars["Nový balíček"]
            XCTAssertTrue(navBar.waitForExistence(timeout: 5), "Nejsem na obrazovce 'Nový balíček'")
        }

    func testCreatePackageWithColor() {
        let nameField = app.textFields["packageNameField"]
        let createButton = app.buttons["createPackageButton"]
        
        // 1. Zadat název
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText("Fyzika")
        
        // 2. Vybrat červenou barvu
        // OPRAVA: Kruhy (Circle) se ve SwiftUI často hlásí jako 'images', ne 'otherElements'
        let redColor = app.images["color_red"]
        
        if redColor.exists {
            redColor.tap()
        } else {
            // Fallback: Pokud to není image, zkusíme tlačítko
            app.buttons["color_red"].tap()
        }
        
        // 3. Uložit
        // Ujistíme se, že tlačítko je aktivní (pole není prázdné)
        let isEnabledPredicate = NSPredicate(format: "isEnabled == true")
        expectation(for: isEnabledPredicate, evaluatedWith: createButton, handler: nil)
        waitForExpectations(timeout: 2.0, handler: nil)
        
        createButton.tap()
        
        // 4. Ověření zavření modálního okna
        let navBar = app.navigationBars["Nový balíček"]
        let doesNotExist = NSPredicate(format: "exists == false")
        expectation(for: doesNotExist, evaluatedWith: navBar, handler: nil)
        waitForExpectations(timeout: 2.0, handler: nil)
        
        // 5. Ověření v seznamu
        // Hledáme text "Fyzika" v seznamu balíčků
        let newPackage = app.staticTexts["Fyzika"]
        XCTAssertTrue(newPackage.waitForExistence(timeout: 2), "Nový balíček 'Fyzika' se neobjevil v seznamu.")
    }
}
*/
