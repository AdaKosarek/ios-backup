//
//  SessionViewModelTests.swift
//  StudySync
//
//  Created by mp on 16.01.2026.
//

import XCTest
@testable import StudySync

@MainActor
final class SessionViewModelTests: XCTestCase {
    
    var viewModel: SessionViewModel!
    var mockService: MockDataService!
    var testCards: [StudyCard]!
    
    override func setUp() {
        super.setUp()
        mockService = MockDataService()
        
        testCards = [
            StudyCard(question: "Q1", answer: "A1"),
            StudyCard(question: "Q2", answer: "A2"),
            StudyCard(question: "Q3", answer: "A3")
        ]
        
        viewModel = SessionViewModel(cards: testCards, dataService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        testCards = nil
        super.tearDown()
    }
    
    func test_FlipCard_ShouldToggleState() {
        XCTAssertFalse(viewModel.isFlipped)
        
        viewModel.flipCard()
        XCTAssertTrue(viewModel.isFlipped)
        
        viewModel.flipCard()
        XCTAssertFalse(viewModel.isFlipped)
    }
    
    func test_MarkCorrect_ShouldIncreaseScoreAndMoveToNext() {
        let initialIndex = viewModel.currentIndex
        
        viewModel.markCorrect()
        
        XCTAssertEqual(viewModel.correctCount, 1)
        XCTAssertEqual(viewModel.incorrectCount, 0)
        XCTAssertEqual(viewModel.currentIndex, initialIndex + 1)
        
        XCTAssertFalse(viewModel.isFlipped)
    }
    
    func test_MarkIncorrect_ShouldIncreaseIncorrectCount() {
        viewModel.markIncorrect()
        
        XCTAssertEqual(viewModel.correctCount, 0)
        XCTAssertEqual(viewModel.incorrectCount, 1)
    }

    
    func test_Progress_ShouldCalculateCorrectly() {
        XCTAssertEqual(viewModel.progress, 0.0)
        viewModel.markCorrect() // index 1
        XCTAssertEqual(viewModel.progress, 1.0/3.0, accuracy: 0.001)
    }
}
