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
    
    var packagesCount: Int { connector.receivedPackages.count }
    var cardsCount: Int {
        connector.receivedPackages.reduce(0) { $0 + $1.groups.reduce(0) { $0 + $1.cards.count } }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Přehled")
                    .font(.headline)
                
                CircularProgressView(
                    progress: viewModel.accuracyProgress,
                    title: viewModel.accuracyText,
                    subtitle: "Úspěšnost",
                    color: .green
                )
                .frame(height: 110)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    
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
