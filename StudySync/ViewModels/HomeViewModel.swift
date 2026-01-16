//
//  HomeViewModel.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import Observation

@Observable
class HomeViewModel {
    private let dataService: DataServiceProtocol
    
    var sessions: [StudySession] = []
    var streak: Int = 0
    var totalXP: Int = 0
    var cardsStudiedToday: Int = 0
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadData()
    }
    
    func loadData() {
        do {
            self.sessions = try dataService.fetchSessions()
            calculateStats()
        } catch {
            print("Error loading sessions: \(error)")
        }
    }
    
    private func calculateStats() {
        // Logika přesunuta z View sem
        let todaySessions = sessions.filter { Calendar.current.isDateInToday($0.date) }
        cardsStudiedToday = todaySessions.reduce(0) { $0 + $1.totalCards }
        
        let totalCorrect = sessions.reduce(0) { $0 + $1.correctCount }
        totalXP = totalCorrect * 10
        
        if sessions.contains(where: { Calendar.current.isDateInToday($0.date) }) {
            streak = 1 // Zjednodušená logika streaku
        } else {
            streak = 0
        }
    }
}
