import XCTest

final class CardListUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Načteme data s předpřipravenou kartou "Fixní Otázka"
        app.launchArguments.append("--mock-data")
        app.launch()
    }

    // Jednoduchá navigace k hotovému
    func navigateToCardList() {
        // 1. Library
        let libraryTab = app.tabBars.buttons["Library"]
        XCTAssertTrue(libraryTab.waitForExistence(timeout: 5))
        libraryTab.tap()
        
        // 2. Balíček
        let packageRow = app.buttons["PackageRow_Matematika"]
        XCTAssertTrue(packageRow.waitForExistence(timeout: 5))
        packageRow.tap()
        
        // 3. Skupina (Už tam je z Mock dat, nemusíme nic vytvářet)
        let groupRow = app.staticTexts["Testovací Skupina"]
        XCTAssertTrue(groupRow.waitForExistence(timeout: 5), "Skupina z Mock dat se nenačetla.")
        groupRow.tap()
        
        // 4. Jsme v seznamu?
        XCTAssertTrue(app.buttons["AddCardButton"].waitForExistence(timeout: 5))
    }

    // --- TEST 1: Ověření, že předpřipravená karta existuje ---
    func testPrecreatedCardIsVisible() {
        navigateToCardList()
        
        // Hledáme text, který jsme zadali v UITestLauncheru
        let card = app.staticTexts["Fixní Otázka"]
        XCTAssertTrue(card.exists, "Předpřipravená karta není v seznamu vidět.")
    }

    // --- TEST 2: Smazání předpřipravené karty ---
    func testDeletePrecreatedCard() {
        navigateToCardList()
        
        let card = app.staticTexts["Fixní Otázka"]
        XCTAssertTrue(card.waitForExistence(timeout: 5), "Karta k smazání tam není.")
        
        // Gesto pro smazání
        card.swipeLeft()
        
        // Kliknutí na Delete/Smazat
        let deleteBtn = app.buttons["Delete"]
        if deleteBtn.exists {
            deleteBtn.tap()
        } else {
            app.buttons["Smazat"].tap()
        }
        
        // Ověření, že zmizela
        // Použijeme predikát, abychom počkali na dokončení animace zmizení
        let doesNotExist = NSPredicate(format: "exists == false")
        expectation(for: doesNotExist, evaluatedWith: card, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
        
        XCTAssertFalse(card.exists, "Karta po smazání stále existuje.")
    }
}
