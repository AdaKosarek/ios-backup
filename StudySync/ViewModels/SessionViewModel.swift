//
//  SessionViewModel.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import Observation

@Observable
class SessionViewModel {
    private let dataService: DataServiceProtocol
    
    var cards: [StudyCard]
    var currentIndex: Int = 0
    var isFlipped: Bool = false
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var isFinished: Bool = false
    
    init(cards: [StudyCard], dataService: DataServiceProtocol) {
        self.cards = cards.shuffled() // Zamíchat karty
        self.dataService = dataService
    }
    
    var currentCard: StudyCard? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }
    
    var progress: Double {
        guard !cards.isEmpty else { return 0 }
        return Double(currentIndex) / Double(cards.count)
    }
    
    func flipCard() {
        isFlipped.toggle()
    }
    
    func markCorrect() {
        correctCount += 1
        currentCard?.successfulAttempts += 1
        currentCard?.lastReviewed = Date()
        nextCard()
    }
    
    func markIncorrect() {
        incorrectCount += 1
        currentCard?.failedAttempts += 1
        currentCard?.lastReviewed = Date()
        nextCard()
    }
    
    private func nextCard() {
        isFlipped = false
        if currentIndex < cards.count - 1 {
            currentIndex += 1
        } else {
            finishSession()
        }
    }
    
    private func finishSession() {
        isFinished = true
        let session = StudySession(correctCount: correctCount, incorrectCount: incorrectCount)
        dataService.saveSession(session)
    }
}
