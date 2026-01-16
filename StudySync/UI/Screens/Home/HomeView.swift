//
//  HomeView.swift
//  StudySync
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var viewModel: HomeViewModel
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        DailyGoalWidget(cardsStudiedToday: viewModel.cardsStudiedToday)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            HomeStatCard(title: "Streak", value: "\(viewModel.streak) dní", icon: "flame.fill", color: .orange)
                            HomeStatCard(title: "Total XP", value: "\(viewModel.totalXP)", icon: "star.fill", color: .yellow)
                            HomeStatCard(title: "Další studium", value: "2 hod", icon: "clock.fill", color: .purple)
                            HomeStatCard(title: "Dnes hotovo", value: "\(viewModel.cardsStudiedToday)", icon: "checkmark.circle.fill", color: .green)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                .navigationTitle("Today")
                .onAppear {
                    // Pokaždé když se view ukáže, načteme čerstvá data
                    viewModel.loadData()
                }
            }
        }
    }
    /*
    // Výpočty zůstávají stejné...
    private func calculateCardsToday() -> Int {
        let todaySessions = sessions.filter { Calendar.current.isDateInToday($0.date) }
        return todaySessions.reduce(0) { $0 + $1.totalCards }
    }
    
    private func calculateTotalXP() -> Int {
        let totalCorrect = sessions.reduce(0) { $0 + $1.correctCount }
        return totalCorrect * 10
    }
    
    private func calculateStreak() -> Int {
        if sessions.contains(where: { Calendar.current.isDateInToday($0.date) }) {
            return 1
        }
        return 0
    }
}
*/
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
                // PŘIDÁNO: ID pro hodnotu (např. value_Streak)
                .accessibilityIdentifier("value_\(title)")
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        // PŘIDÁNO: ID pro celou kartu
        .accessibilityIdentifier("statCard_\(title)")
    }
}
