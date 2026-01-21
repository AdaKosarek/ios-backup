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
            
            // 1. Najdeme kartu ("Fixní Otázka" z Mock dat)
            let card = app.buttons["CardRow_Fixní Otázka"] // Pozor: v CardListView máte identifier nastavený na "CardRow_\(card.question)" a je to Button
            
            // Pokud by identifier nefungoval, zkusíme najít text uvnitř
            if !card.exists {
                 let staticText = app.staticTexts["Fixní Otázka"]
                 XCTAssertTrue(staticText.waitForExistence(timeout: 5), "Karta k smazání tam není.")
                 // Musíme klikat na element, který má kontextové menu (což je ten Button/Row)
                 // Pro test použijeme coordinate tap nebo najdeme nadřazený prvek, ale identifier je nejjistější.
            } else {
                 XCTAssertTrue(card.waitForExistence(timeout: 5), "Karta k smazání tam není.")
            }
            
            // 2. Místo swipeLeft() použijeme DLOUHÝ STISK pro otevření kontextového menu
            card.press(forDuration: 1.0)
            
            // 3. Najdeme tlačítko v kontextovém menu
            // V CardListView máte: Label("Smazat kartu", systemImage: "trash")
            let contextMenuDeleteButton = app.buttons["Smazat kartu"]
            
            // Čekáme, až se menu objeví
            XCTAssertTrue(contextMenuDeleteButton.waitForExistence(timeout: 3), "Kontextové menu se neotevřelo nebo v něm není tlačítko 'Smazat kartu'.")
            
            // 4. Klikneme na smazat
            contextMenuDeleteButton.tap()
            
            // 5. Ověření zmizení
            let doesNotExist = NSPredicate(format: "exists == false")
            
            // Pozor: Musíme čekat na zmizení té původní karty
            expectation(for: doesNotExist, evaluatedWith: card, handler: nil)
            waitForExpectations(timeout: 5.0, handler: nil)
            
            XCTAssertFalse(card.exists, "Karta po smazání stále existuje.")
        }
}
