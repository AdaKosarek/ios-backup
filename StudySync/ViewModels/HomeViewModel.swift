//
//  HomeViewModel.swift
//  StudySync
//
//  Created by mp on 16.01.2026.
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
            let statsVM = StatisticsViewModel(dataService: dataService)
            statsVM.refreshData()

            let statsDTO = statsVM.makeWatchStatsDTO()

            DispatchQueue.main.async {
                WatchConnector.shared.sendStatsToWatch(statsDTO)
            }
        } catch {
            print("Error loading sessions: \(error)")
        }
    }
    
    private func calculateStats() {
        let todaySessions = sessions.filter { Calendar.current.isDateInToday($0.date) }
        cardsStudiedToday = todaySessions.reduce(0) { $0 + $1.totalCards }
        
        let totalCorrect = sessions.reduce(0) { $0 + $1.correctCount }
        totalXP = totalCorrect * 10
        
        streak = calculateStreak()
    }
    
    private func calculateStreak() -> Int {
        var streak = 0
        let calendar = Calendar.current
        var checkDate = Date()
        if getCardsCount(for: checkDate, granularity: .day) == 0 { checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)! }
        while getCardsCount(for: checkDate, granularity: .day) > 0 {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        return streak
    }
    
    private func getCardsCount(for date: Date, granularity: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return sessions.filter {
            calendar.isDate($0.date, equalTo: date, toGranularity: granularity)
        }.reduce(0) { $0 + $1.totalCards }
    }
    
}
