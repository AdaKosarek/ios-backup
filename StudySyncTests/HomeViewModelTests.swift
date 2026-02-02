//
//  HomeViewModelTests.swift
//  StudySync
//
//  Created by mp on 16.01.2026.
//

import XCTest
@testable import StudySync

@MainActor
final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockService: MockDataService!

    override func setUp() {
        super.setUp()
        mockService = MockDataService()
        viewModel = HomeViewModel(dataService: mockService!)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func test_InitialState_ShouldBeZero() {
        XCTAssertEqual(viewModel.totalXP, 0)
        XCTAssertEqual(viewModel.streak, 0)
        XCTAssertEqual(viewModel.cardsStudiedToday, 0)
    }
}
