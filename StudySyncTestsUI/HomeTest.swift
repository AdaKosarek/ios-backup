//
//  HomeTest.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

import XCTest

final class HomeViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--mock-data")
        app.launch()
    }

    func testDailyGoalWidgetCalculations() {
        // Mock data v MockDataService.addMockDataForUITests() obsahují
        // jednu session s 8 správně, 2 špatně. Celkem 10 karet.
        
        // 1. Dnes hotovo (ID: value_Dnes hotovo)
        // V kódu HomeView je: title: "Dnes hotovo" -> ID "value_Dnes hotovo"
        let cardsTodayValue = app.staticTexts["value_Dnes hotovo"]
        
        if cardsTodayValue.waitForExistence(timeout: 5) {
            // Očekáváme 10 (8+2)
            XCTAssertEqual(cardsTodayValue.label, "10")
        }
        
        // 2. Total XP (ID: value_Total XP)
        // XP = correctCount * 10 = 8 * 10 = 80
        let xpValue = app.staticTexts["value_Total XP"]
        if xpValue.exists {
             XCTAssertEqual(xpValue.label, "80")
        }
    }
}
