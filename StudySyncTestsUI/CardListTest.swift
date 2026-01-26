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
            let libraryTab = app.tabBars.buttons["LibraryTab"]
            
            if !libraryTab.exists {
                let textTab = app.tabBars.buttons["Knihovna"]
                if textTab.exists {
                    textTab.tap()
                } else {
                    XCTFail("Nelze najít záložku Knihovna (ani podle ID 'LibraryTab', ani podle textu 'Knihovna')")
                }
            } else {
                libraryTab.tap()
            }

            let packageRow = app.buttons["PackageRow_Matematika"]
            
            if packageRow.waitForExistence(timeout: 5) {
                packageRow.tap()
            } else {
                app.staticTexts["Matematika"].tap()
            }
            
            let groupName = "Testovací Skupina"
            let groupText = app.staticTexts[groupName]
            
            XCTAssertTrue(groupText.waitForExistence(timeout: 5), "Skupina '\(groupName)' nebyla nalezena.")
            groupText.tap()
        }
}
