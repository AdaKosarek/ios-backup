//
//  BaseUITestCase.swift
//  StudySync
//
//  Created by mp on 25.01.2026.
//

import XCTest
class BaseUITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = [
            "--ui-testing",
            "--mock-data"
        ]
        app.launch()
    }
}
