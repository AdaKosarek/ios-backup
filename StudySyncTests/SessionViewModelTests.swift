//
//  SessionViewModelTests.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
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
        
        // Vytvoříme testovací karty
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
        // Na začátku není otočená
        XCTAssertFalse(viewModel.isFlipped)
        
        // Otočíme
        viewModel.flipCard()
        XCTAssertTrue(viewModel.isFlipped)
        
        // Otočíme zpět
        viewModel.flipCard()
        XCTAssertFalse(viewModel.isFlipped)
    }
    
    func test_MarkCorrect_ShouldIncreaseScoreAndMoveToNext() {
        // Arrange
        let initialIndex = viewModel.currentIndex
        
        // Act
        viewModel.markCorrect()
        
        // Assert
        XCTAssertEqual(viewModel.correctCount, 1)
        XCTAssertEqual(viewModel.incorrectCount, 0)
        XCTAssertEqual(viewModel.currentIndex, initialIndex + 1)
        
        // Ověříme, že se karta otočila zpět "rubem nahoru" pro další kolo
        XCTAssertFalse(viewModel.isFlipped)
    }
    
    func test_MarkIncorrect_ShouldIncreaseIncorrectCount() {
        viewModel.markIncorrect()
        
        XCTAssertEqual(viewModel.correctCount, 0)
        XCTAssertEqual(viewModel.incorrectCount, 1)
    }
    
    func test_CompleteSession_ShouldSaveToService() {
        // Máme 3 karty. Projdeme je všechny.
        viewModel.markCorrect() // 1. karta
        viewModel.markCorrect() // 2. karta
        viewModel.markCorrect() // 3. karta -> tady by se mělo zavolat finish
        
        // Assert
        XCTAssertTrue(viewModel.isFinished)
        
        // Klíčový test: Uložila se session do naší mock databáze?
        XCTAssertEqual(mockService.sessions.count, 1)
        
        let savedSession = mockService.sessions.first
        XCTAssertEqual(savedSession?.correctCount, 3)
        XCTAssertEqual(savedSession?.totalCards, 3)
    }
    
    func test_Progress_ShouldCalculateCorrectly() {
        // 3 karty, index 0
        XCTAssertEqual(viewModel.progress, 0.0)
        
        viewModel.markCorrect() // index 1
        // 1 / 3 = 0.333...
        XCTAssertEqual(viewModel.progress, 1.0/3.0, accuracy: 0.001)
    }
}
