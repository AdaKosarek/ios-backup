//
//  HomeViewModelTests.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
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
        // Inicializujeme ViewModel s Mock službou
        viewModel = HomeViewModel(dataService: mockService!)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func test_InitialState_ShouldBeZero() {
        // Pokud databáze je prázdná, statistiky musí být 0
        XCTAssertEqual(viewModel.totalXP, 0)
        XCTAssertEqual(viewModel.streak, 0)
        XCTAssertEqual(viewModel.cardsStudiedToday, 0)
    }

    func test_CalculateStats_ShouldComputeCorrectly() {
        // Arrange (Příprava dat)
        // Vytvoříme 2 sezení:
        // 1. Dnes: 5 správně, 2 špatně (Celkem 7 karet)
        // 2. Včera (nebo starší): 10 správně, 0 špatně (Celkem 10 karet) - simulujeme tím, že se nepočítá do "Dnes"
        
        let sessionToday = StudySession(correctCount: 5, incorrectCount: 2)
        // Session automaticky dostává Date(), což je "teď".
        
        // Přidáme data do mocku
        mockService.sessions = [sessionToday]
        
        // Act (Akce - načtení dat)
        viewModel.loadData()
        
        // Assert (Ověření)
        
        // 1. XP = (5 správně) * 10 = 50 XP
        XCTAssertEqual(viewModel.totalXP, 50)
        
        // 2. Cards Today = 5 + 2 = 7
        XCTAssertEqual(viewModel.cardsStudiedToday, 7)
        
        // 3. Streak = 1 (protože máme záznam z dneška)
        XCTAssertEqual(viewModel.streak, 1)
    }
}
