//
//  CardListViewModelTests.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import XCTest
@testable import StudySync

@MainActor
final class CardListViewModelTests: XCTestCase {
    
    var viewModel: CardListViewModel!
    var mockService: MockDataService!
    var testGroup: StudyGroup!
    
    override func setUp() {
        super.setUp()
        mockService = MockDataService()
        
        testGroup = StudyGroup(name: "Test Group")
        
        viewModel = CardListViewModel(group: testGroup, dataService: mockService!)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        testGroup = nil
        super.tearDown()
    }
    
    func test_AddCard_ShouldAddCardToGroup() {
        viewModel.addCard(question: "Kolik je 2+2?", answer: "4")
        
        XCTAssertEqual(testGroup.cards.count, 1)
        let card = testGroup.cards.first
        XCTAssertEqual(card?.question, "Kolik je 2+2?")
        XCTAssertEqual(card?.answer, "4")
    }
    
}
