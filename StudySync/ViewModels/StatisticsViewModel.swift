//
//  Untitled.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import Observation
import SwiftData
import SwiftUI

enum StatsRange: String, CaseIterable {
    case week = "Týden"
    case month = "Měsíc"
    case year = "Rok"
}

@Observable
class StatisticsViewModel {
    private let dataService: DataServiceProtocol
    
    var sessions: [StudySession] = []
    
    // UI State
    var selectedRange: StatsRange = .week {
        didSet {
            // Při změně filtru přepočítáme graf I KARTIČKY
            recalculateAll()
        }
    }
    
    var chartData: [ChartPoint] = []
    
    // Statistiky (nyní se budou měnit podle filtru)
    var overallAccuracy: Double = 0
    var totalXP: Int = 0
    var totalCardsStudied: Int = 0
    
    // Streak necháme globální (je to aktuální série), nebo ho můžeš taky filtrovat
    var streakDays: Int = 0
    
    struct ChartPoint: Identifiable {
        let id = UUID()
        let label: String
        let value: Int
        let date: Date
        var color: Color {
            value > 20 ? .green : (value > 0 ? .blue : .gray.opacity(0.3))
        }
    }

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func refreshData() {
        do {
            self.sessions = try dataService.fetchSessions()
            recalculateAll()
        } catch {
            print("Chyba načítání: \(error)")
        }
    }
    
    // Hlavní funkce, která spustí všechny výpočty
    private func recalculateAll() {
        calculateAggregatedStats() // Kartičky
        calculateChartData()       // Graf
    }
    
    // MARK: - Výpočet statistik pro kartičky (Upraveno pro filtrování)
    private func calculateAggregatedStats() {
        // 1. Nejprve spočítáme Streak (ten je vždy globální - aktuální série)
        streakDays = calculateStreak()
        
        // 2. Pro ostatní statistiky vyfiltrujeme sessions podle zvoleného období
        let filteredSessions = getSessionsForSelectedRange()
        
        // 3. Spočítáme hodnoty jen z vyfiltrovaných dat
        totalCardsStudied = filteredSessions.reduce(0) { $0 + $1.totalCards }
        let totalCorrect = filteredSessions.reduce(0) { $0 + $1.correctCount }
        
        // Ošetření dělení nulou
        overallAccuracy = totalCardsStudied > 0 ? (Double(totalCorrect) / Double(totalCardsStudied)) * 100 : 0
        
        // XP (např. 10 bodů za správnou odpověď)
        totalXP = totalCorrect * 10
    }
    
    // Pomocná funkce: Vrátí jen sessions, které spadají do vybraného období
    private func getSessionsForSelectedRange() -> [StudySession] {
        let calendar = Calendar.current
        let today = Date()
        
        // Určíme datum, od kterého nás to zajímá
        let cutoffDate: Date?
        
        switch selectedRange {
        case .week:
            cutoffDate = calendar.date(byAdding: .day, value: -7, to: today)
        case .month:
            cutoffDate = calendar.date(byAdding: .day, value: -30, to: today)
        case .year:
            cutoffDate = calendar.date(byAdding: .month, value: -12, to: today)
        }
        
        guard let start = cutoffDate else { return sessions }
        
        // Vrátíme jen sessions novější než cutoffDate
        return sessions.filter { $0.date >= start }
    }
    
    // MARK: - Generátor Mock Dat
    func generateMockData() {
        let calendar = Calendar.current
        let today = Date()
        var newSessions: [StudySession] = []
        
        // Vygenerujeme data pro posledních 100 dní (aby bylo dost dat i pro roční pohled)
        for i in 0..<100 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            
            // 60% šance, že se ten den učil
            if Int.random(in: 1...100) > 40 {
                let cardsCount = Int.random(in: 10...60)
                // Náhodná úspěšnost mezi 50% a 100%
                let correct = Int(Double(cardsCount) * Double.random(in: 0.5...1.0))
                
                let session = StudySession(correctCount: correct, incorrectCount: cardsCount - correct)
                session.date = date // Simulace staršího data
                
                newSessions.append(session)
            }
        }
        
        self.sessions = newSessions
        recalculateAll()
    }
    
    // MARK: - Graf (Zůstává stejný, jen pro úplnost)
    private func calculateChartData() {
        let calendar = Calendar.current
        let today = Date()
        var points: [ChartPoint] = []
        
        let daysBack = selectedRange == .week ? 7 : (selectedRange == .month ? 30 : 12)
        let granularity: Calendar.Component = selectedRange == .year ? .month : .day
        
        for i in (0..<daysBack).reversed() {
            if let date = calendar.date(byAdding: granularity, value: -i, to: today) {
                let label = getLabel(for: date, range: selectedRange)
                let count = getCardsCount(for: date, granularity: granularity)
                points.append(ChartPoint(label: label, value: count, date: date))
            }
        }
        self.chartData = points
    }
    
    private func getLabel(for date: Date, range: StatsRange) -> String {
        let formatter = DateFormatter()
        if range == .year {
            formatter.dateFormat = "MMM"
        } else if range == .month {
             formatter.dateFormat = "d"
        } else {
            formatter.dateFormat = "EE"
        }
        return formatter.string(from: date)
    }

    private func getCardsCount(for date: Date, granularity: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return sessions.filter {
            calendar.isDate($0.date, equalTo: date, toGranularity: granularity)
        }.reduce(0) { $0 + $1.totalCards }
    }
    
    private func calculateStreak() -> Int {
        var streak = 0
        let calendar = Calendar.current
        var checkDate = Date()
        
        if getCardsCount(for: checkDate, granularity: .day) == 0 {
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        
        while getCardsCount(for: checkDate, granularity: .day) > 0 {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        return streak
    }
}
