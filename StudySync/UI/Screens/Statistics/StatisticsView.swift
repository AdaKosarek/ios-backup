//
//  StatisticsView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData
import Charts // Důležitý import pro grafy

struct StatisticsView: View {
    // Načteme všechny sessions seřazené od nejnovější
    @Query(sort: \StudySession.date, order: .forward) private var sessions: [StudySession]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 1. KARTA: Celková přesnost
                    VStack(alignment: .leading) {
                        Text("Celková úspěšnost")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Text("\(calculateOverallAccuracy())%")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chart.pie.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        
                        ProgressView(value: Double(calculateOverallAccuracy()), total: 100)
                            .tint(.white)
                            .padding(.top, 5)
                    }
                    .padding()
                    .background(Color.green.gradient) // Barva z Figmy
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // 2. KARTA: Graf historie (Bar Chart)
                    VStack(alignment: .leading) {
                        Text("Tento týden")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        if sessions.isEmpty {
                            ContentUnavailableView("Zatím žádná data", systemImage: "chart.bar")
                                .frame(height: 200)
                        } else {
                            Chart {
                                ForEach(sessions) { session in
                                    BarMark(
                                        x: .value("Datum", session.date, unit: .day),
                                        y: .value("Karty", session.totalCards)
                                    )
                                    .foregroundStyle(Color.blue.gradient)
                                    .cornerRadius(5)
                                }
                            }
                            .frame(height: 250)
                            // Nastavení osy X na dny
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day)) { value in
                                    AxisValueLabel(format: .dateTime.weekday())
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // 3. STATISTIKY V ČÍSLECH
                    HStack(spacing: 15) {
                        StatBox(title: "Celkem karet", value: "\(calculateTotalCards())", icon: "rectangle.stack.fill", color: .blue)
                        StatBox(title: "Sessions", value: "\(sessions.count)", icon: "play.circle.fill", color: .orange)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Statistiky")
        }
    }
    
    // --- POMOCNÉ VÝPOČTY ---
    
    private func calculateOverallAccuracy() -> Int {
        let totalCorrect = sessions.reduce(0) { $0 + $1.correctCount }
        let totalAll = sessions.reduce(0) { $0 + $1.totalCards }
        
        guard totalAll > 0 else { return 0 }
        return Int((Double(totalCorrect) / Double(totalAll)) * 100)
    }
    
    private func calculateTotalCards() -> Int {
        sessions.reduce(0) { $0 + $1.totalCards }
    }
}

// Malá komponenta pro čtverečky dole
struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title2)
                .padding(.bottom, 5)
            
            Text(value)
                .font(.title)
                .bold()
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    StatisticsView()
}
