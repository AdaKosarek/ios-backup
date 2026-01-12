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
        // Důležité: Tímto řekneme aplikaci, aby použila Mock data
        app.launchArguments.append("--mock-data")
        app.launch()
    }

    func testDailyGoalWidgetCalculations() {
        let app = XCUIApplication()
        
        // 1. Kontrola Streak - hledáme prvek, který má identifikátor "value_Streak"
        // Pokud ho nemůže najít podle ID, zkusíme label, který vidíme v snapshotu
        let streakValue = app.staticTexts["value_Streak"]
        
        if streakValue.waitForExistence(timeout: 5) {
            XCTAssertEqual(streakValue.label, "1 dní")
        } else {
            // Alternativní cesta: Hledáme StaticText, který obsahuje text "1 dní"
            let fallbackStreak = app.staticTexts["1 dní"]
            XCTAssertTrue(fallbackStreak.exists, "Nepodařilo se najít text '1 dní' ani podle ID, ani podle labelu.")
        }

        // 2. Kontrola XP - ve tvém snapshotu vidíme: identifier: 'statCard_Total XP', label: '80'
        // To znamená, že tvoje ID "value_Total XP" se v aplikaci přepsalo na "statCard_Total XP"
        let xpValue = app.staticTexts["statCard_Total XP"].firstMatch
        XCTAssertTrue(xpValue.waitForExistence(timeout: 5))
        XCTAssertEqual(xpValue.label, "80")
    }
}
