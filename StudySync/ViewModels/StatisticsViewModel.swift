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
        didSet { recalculateAll() }
    }
    
    var chartData: [ChartPoint] = []
    
    // Statistiky
    var overallAccuracy: Double = 0
    var totalXP: Int = 0
    var totalCardsStudied: Int = 0
    var streakDays: Int = 0
    
    // Nové metriky
    var consistency: Double = 0       // Pravidelnost v %
    var trendPercentage: Double = 0   // Změna oproti minulu v %
    
    // Denní cíl (pro přerušovanou čáru v grafu)
    var dailyGoal: Int = 20
    
    struct ChartPoint: Identifiable, Equatable {
        let id = UUID()
        let label: String
        let value: Int
        let date: Date
        var color: Color {
            value >= 20 ? .green : (value > 0 ? .blue : .gray.opacity(0.3))
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
    
    // Helper pro interaktivitu grafu
    func findChartItem(for date: Date) -> ChartPoint? {
        return chartData.min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) })
    }
    
    // MARK: - Hlavní výpočty
    
    private func recalculateAll() {
        calculateAggregatedStats()
        calculateChartData()
        calculateTrend()
    }
    
    private func calculateAggregatedStats() {
        // 1. Streak (počítá se globálně k dnešnímu dni)
        streakDays = calculateStreak()
        
        // 2. Filtrace dat pro aktuální období
        let filteredSessions = getSessionsForSelectedRange()
        
        // 3. Základní součty
        totalCardsStudied = filteredSessions.reduce(0) { $0 + $1.totalCards }
        let totalCorrect = filteredSessions.reduce(0) { $0 + $1.correctCount }
        
        overallAccuracy = totalCardsStudied > 0 ? (Double(totalCorrect) / Double(totalCardsStudied)) * 100 : 0
        totalXP = totalCorrect * 10
        
        // 4. Výpočet Pravidelnosti (Consistency)
        let calendar = Calendar.current
        // Počet unikátních dní, kdy se uživatel učil
        let uniqueDaysStudied = Set(filteredSessions.map { calendar.startOfDay(for: $0.date) }).count
        
        // Celkový počet dní v období
        let totalDaysInRange: Int
        switch selectedRange {
        case .week: totalDaysInRange = 7
        case .month: totalDaysInRange = 30
        case .year: totalDaysInRange = 365
        }
        
        consistency = (Double(uniqueDaysStudied) / Double(totalDaysInRange)) * 100
    }
    
    private func calculateTrend() {
        let calendar = Calendar.current
        let today = Date()
        
        // 1. Definice intervalů (Tento vs Minulý)
        let currentStartDate: Date?
        let previousStartDate: Date?
        let previousEndDate: Date?
        
        switch selectedRange {
        case .week:
            currentStartDate = calendar.date(byAdding: .day, value: -7, to: today)
            previousEndDate = currentStartDate
            previousStartDate = calendar.date(byAdding: .day, value: -14, to: today)
        case .month:
            currentStartDate = calendar.date(byAdding: .day, value: -30, to: today)
            previousEndDate = currentStartDate
            previousStartDate = calendar.date(byAdding: .day, value: -60, to: today)
        case .year:
            currentStartDate = calendar.date(byAdding: .month, value: -12, to: today)
            previousEndDate = currentStartDate
            previousStartDate = calendar.date(byAdding: .month, value: -24, to: today)
        }
        
        guard let currentStart = currentStartDate,
              let prevStart = previousStartDate,
              let prevEnd = previousEndDate else {
            trendPercentage = 0
            return
        }
        
        // 2. Data pro období
        let currentCards = sessions.filter { $0.date >= currentStart }.reduce(0) { $0 + $1.totalCards }
        let previousCards = sessions.filter { $0.date >= prevStart && $0.date < prevEnd }.reduce(0) { $0 + $1.totalCards }
        
        // 3. Výpočet procentuální změny
        if previousCards == 0 {
            trendPercentage = currentCards > 0 ? 100 : 0
        } else {
            let diff = Double(currentCards - previousCards)
            trendPercentage = (diff / Double(previousCards)) * 100
        }
    }
    
    // MARK: - Graf a Data
    
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
    
    // Helpery
    private func getSessionsForSelectedRange() -> [StudySession] {
        let calendar = Calendar.current
        let today = Date()
        let cutoffDate: Date?
        
        switch selectedRange {
        case .week: cutoffDate = calendar.date(byAdding: .day, value: -7, to: today)
        case .month: cutoffDate = calendar.date(byAdding: .day, value: -30, to: today)
        case .year: cutoffDate = calendar.date(byAdding: .month, value: -12, to: today)
        }
        
        guard let start = cutoffDate else { return sessions }
        return sessions.filter { $0.date >= start }
    }
    
    private func getLabel(for date: Date, range: StatsRange) -> String {
        let formatter = DateFormatter()
        if range == .year { formatter.dateFormat = "MMM" }
        else if range == .month { formatter.dateFormat = "d.M." }
        else { formatter.dateFormat = "EE" }
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
        if getCardsCount(for: checkDate, granularity: .day) == 0 { checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)! }
        while getCardsCount(for: checkDate, granularity: .day) > 0 {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        return streak
    }
    
    // MARK: - Mock Data Generátor
    func generateMockData() {
        let calendar = Calendar.current
        let today = Date()
        var newSessions: [StudySession] = []
        
        for i in 0..<100 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            // 60% šance na učení
            if Int.random(in: 1...100) > 40 {
                let cardsCount = Int.random(in: 5...60)
                let correct = Int(Double(cardsCount) * Double.random(in: 0.6...1.0))
                let session = StudySession(correctCount: correct, incorrectCount: cardsCount - correct)
                session.date = date
                newSessions.append(session)
            }
        }
        self.sessions = newSessions
        recalculateAll()
    }
}
