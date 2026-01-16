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
            // 1. Kliknutí na Tab (používáme ID, které jsme přidali v kroku 1)
            let libraryTab = app.tabBars.buttons["LibraryTab"]
            
            // Pokud ID neexistuje, zkusíme záložní řešení podle textu (pro jistotu)
            if !libraryTab.exists {
                let textTab = app.tabBars.buttons["Knihovna"] // Zkusíme česky
                if textTab.exists {
                    textTab.tap()
                } else {
                    XCTFail("Nelze najít záložku Knihovna (ani podle ID 'LibraryTab', ani podle textu 'Knihovna')")
                }
            } else {
                libraryTab.tap()
            }
            
            // 2. Kliknutí na Balíček (Matematika)
            // Hledáme tlačítko nebo text. V PackagesListView jsi měl identifier "PackageRow_Matematika"
            let packageRow = app.buttons["PackageRow_Matematika"]
            
            if packageRow.waitForExistence(timeout: 5) {
                packageRow.tap()
            } else {
                // Fallback: zkusíme najít jen text
                app.staticTexts["Matematika"].tap()
            }
            
            // 3. Kliknutí na Skupinu (Testovací Skupina - z Mock dat)
            // Pokud používáš --mock-data, musí tam tato skupina být.
            let groupName = "Testovací Skupina" // nebo "Základní" podle toho co máš v mock datech
            let groupText = app.staticTexts[groupName]
            
            XCTAssertTrue(groupText.waitForExistence(timeout: 5), "Skupina '\(groupName)' nebyla nalezena.")
            groupText.tap()
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
