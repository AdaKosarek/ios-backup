//
//  WatchStatsView.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI

struct WatchStatsView: View {
    @State private var connector = WatchConnector.shared
    @State private var viewModel = WatchStatsViewModel()
    
    // Spočítáme balíčky
    var packagesCount: Int { connector.receivedPackages.count }
    
    // Spočítáme karty
    var cardsCount: Int {
        connector.receivedPackages.reduce(0) { $0 + $1.groups.reduce(0) { $0 + $1.cards.count } }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Přehled")
                    .font(.headline)
                
                // 1. Kruh Přesnosti (Zatím statický, dokud nebudeme ukládat historii)
                CircularProgressView(
                    progress: viewModel.accuracyProgress,
                    title: viewModel.accuracyText,
                    subtitle: "Úspěšnost",
                    color: .green
                )
                .frame(height: 110)
                
                // 2. Bento Grid - Napojený na Connector
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    
                    BentoStatCard(
                        title: "Balíčků",
                        value: "\(packagesCount)",
                        icon: "shippingbox.fill",
                        color: .orange
                    )

                    BentoStatCard(
                        title: "Karet",
                        value: "\(cardsCount)",
                        icon: "rectangle.stack.fill",
                        color: .blue
                    )

                    BentoStatCard(
                        title: "XP Dnes",
                        value: "\(viewModel.xpToday)",
                        icon: "star.fill",
                        color: .yellow
                    )

                    BentoStatCard(
                        title: "Série",
                        value: "\(viewModel.streakDays)",
                        icon: "flame.fill",
                        color: .red
                    )
                }
                
                SimpleBarChart(
                    data: viewModel.weeklyCards,
                    labels: ["P", "Ú", "S", "Č", "P", "S", "N"]
                )
            }
            .padding()
        }
    }
}
