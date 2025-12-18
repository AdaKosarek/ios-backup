//
//  HomeView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    // Načteme historii učení
    @Query(sort: \StudySession.date, order: .reverse) private var sessions: [StudySession]
    
    // Potřebujeme vědět aktuální datum pro filtraci
    private var today: Date { Date() }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. Sekce: Widget s denním cílem
                    DailyGoalWidget(cardsStudiedToday: calculateCardsToday())
                        .padding(.horizontal)
                    
                    // 2. Sekce: Mřížka statistik (Grid)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        
                        // Karta: Streak (Zatím jednoduchý výpočet)
                        HomeStatCard(
                            title: "Streak",
                            value: "\(calculateStreak()) dní",
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        // Karta: XP (Zkušenosti)
                        HomeStatCard(
                            title: "Total XP",
                            value: "\(calculateTotalXP())", // 10 XP za správnou odpověď
                            icon: "star.fill",
                            color: .yellow
                        )
                        
                        // Karta: Next Session
                        HomeStatCard(
                            title: "Další studium",
                            value: "2 hod", // Zatím natvrdo, později z notifikací
                            icon: "clock.fill",
                            color: .purple
                        )
                        
                        // Karta: Celkem karet dnes
                        HomeStatCard(
                            title: "Dnes hotovo",
                            value: "\(calculateCardsToday())",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Today")
        }
    }
    
    // --- VÝPOČTY ---
    
    private func calculateCardsToday() -> Int {
        // Vyfiltrujeme sessions, které jsou "dnes"
        let todaySessions = sessions.filter { Calendar.current.isDateInToday($0.date) }
        // Sečteme všechny karty z těchto sessions
        return todaySessions.reduce(0) { $0 + $1.totalCards }
    }
    
    private func calculateTotalXP() -> Int {
        // Jednoduchá gamifikace: 10 bodů za každou správnou odpověď v historii
        let totalCorrect = sessions.reduce(0) { $0 + $1.correctCount }
        return totalCorrect * 10
    }
    
    private func calculateStreak() -> Int {
        // Pokud jsme dnes studovali, máme aspoň 1 den streak
        if sessions.contains(where: { Calendar.current.isDateInToday($0.date) }) {
            return 1
        }
        return 0
    }
}

// Pomocná komponenta pro ty malé čtverečky
struct HomeStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title2)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .bold()
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView()
}
