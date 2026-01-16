import XCTest

final class CardListUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--mock-data")
        app.launch()
    }

    func navigateToCardList() {
        let libraryTab = app.tabBars.buttons["Library"]
        XCTAssertTrue(libraryTab.waitForExistence(timeout: 5))
        libraryTab.tap()
        
        let packageRow = app.buttons["PackageRow_Matematika"]
        XCTAssertTrue(packageRow.waitForExistence(timeout: 5))
        packageRow.tap()
        
        // Použijeme skupinu z Mocku
        let groupRow = app.buttons["groupRow_Testovací Skupina"]
        if groupRow.waitForExistence(timeout: 5) {
             groupRow.tap()
        } else {
             app.staticTexts["Testovací Skupina"].tap()
        }
    }

    func testDeletePrecreatedCard() {
        navigateToCardList()
        
        // "Fixní Otázka" pochází z MockDataService.addMockDataForUITests()
        let card = app.staticTexts["Fixní Otázka"]
        XCTAssertTrue(card.waitForExistence(timeout: 5), "Karta k smazání tam není.")
        
        card.swipeLeft()
        
        let deleteBtn = app.buttons["Delete"] // Anglicky systém
        if deleteBtn.exists {
            deleteBtn.tap()
        } else {
            let smazatBtn = app.buttons["Smazat"] // Česky
            if smazatBtn.exists { smazatBtn.tap() }
        }
        
        // Ověření zmizení
        let doesNotExist = NSPredicate(format: "exists == false")
        expectation(for: doesNotExist, evaluatedWith: card, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
        
        XCTAssertFalse(card.exists, "Karta po smazání stále existuje.")
    }
}
