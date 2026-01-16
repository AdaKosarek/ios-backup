//
//  Untitled.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import Observation
import SwiftData

// Enum pro přepínání rozsahu
enum StatsRange: String, CaseIterable {
    case week = "Týden"
    case month = "Měsíc"
    case year = "Rok"
}

@Observable
class StatisticsViewModel {
    private let dataService: DataServiceProtocol
    
    // Data z databáze
    var sessions: [StudySession] = []
    var packages: [StudyPackage] = []
    
    // Vybraný filtr - při změně se přepočítá graf
    var selectedRange: StatsRange = .week {
        didSet {
            calculateChartData()
        }
    }
    
    // Hlavní statistiky
    var overallAccuracy: Double = 0
    var totalXP: Int = 0
    var streakDays: Int = 0
    
    // Data pro graf
    var chartData: [ChartPoint] = []
    
    // Struktura pro jeden bod v grafu
    struct ChartPoint: Identifiable {
        let id = UUID()
        let label: String    // Např. "Po", "Út" nebo "Leden"
        let value: Int       // Počet karet
        let isGoalMet: Bool  // Splněno (studováno) ten den?
        let date: Date       // Pro řazení
    }

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func refreshData() {
        do {
            self.sessions = try dataService.fetchSessions()
            self.packages = try dataService.fetchPackages()
            
            calculateAggregatedStats()
            calculateChartData() // Voláme výpočet grafu
        } catch {
            print("Chyba při načítání statistik: \(error)")
        }
    }
    
    private func calculateAggregatedStats() {
        let totalCards = sessions.reduce(0) { $0 + $1.totalCards }
        let totalCorrect = sessions.reduce(0) { $0 + $1.correctCount }
        
        overallAccuracy = totalCards > 0 ? (Double(totalCorrect) / Double(totalCards)) * 100 : 0
        totalXP = totalCorrect * 10
        
        streakDays = calculateCurrentStreak()
    }
    
    // --- TOTO JE TA FUNKCE, KTERÁ TI CHYBĚLA ---
    private func calculateChartData() {
        let calendar = Calendar.current
        let today = Date()
        var points: [ChartPoint] = []
        
        switch selectedRange {
        case .week:
            // Posledních 7 dní
            for i in (0..<7).reversed() {
                if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                    let dayName = i == 0 ? "Dnes" : calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
                    let count = getCardsCount(for: date, granularity: .day)
                    points.append(ChartPoint(label: dayName, value: count, isGoalMet: count > 0, date: date))
                }
            }
            
        case .month:
            // Posledních 30 dní
            for i in (0..<30).reversed() {
                if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                    let dayNum = calendar.component(.day, from: date)
                    let label = "\(dayNum)."
                    let count = getCardsCount(for: date, granularity: .day)
                    points.append(ChartPoint(label: label, value: count, isGoalMet: count > 0, date: date))
                }
            }
            
        case .year:
            // Posledních 12 měsíců
            for i in (0..<12).reversed() {
                if let date = calendar.date(byAdding: .month, value: -i, to: today) {
                    let monthName = calendar.shortMonthSymbols[calendar.component(.month, from: date) - 1]
                    let count = getCardsCount(for: date, granularity: .month)
                    points.append(ChartPoint(label: monthName, value: count, isGoalMet: count > 0, date: date))
                }
            }
        }
        
        self.chartData = points
    }
    
    // Pomocná funkce pro sčítání karet
    private func getCardsCount(for date: Date, granularity: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return sessions.filter { session in
            calendar.isDate(session.date, equalTo: date, toGranularity: granularity)
        }.reduce(0) { $0 + $1.totalCards }
    }
    
    private func calculateCurrentStreak() -> Int {
        var streak = 0
        let calendar = Calendar.current
        var checkDate = Date()
        
        // Pokud dnes nebylo nic, zkusíme včerejšek
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
