//
//  WatchStatsView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

struct WatchStatsView: View {
    @State private var connector = WatchConnector.shared
    
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
                    progress: 0.0,
                    title: "0%",
                    subtitle: "Úspěšnost",
                    color: .green
                )
                .frame(height: 110)
                
                // 2. Bento Grid - Napojený na Connector
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    
                    BentoStatCard(title: "Balíčků", value: "\(packagesCount)", icon: "shippingbox.fill", color: .orange)
                    BentoStatCard(title: "Karet", value: "\(cardsCount)", icon: "rectangle.stack.fill", color: .blue)
                    
                    // Placeholder pro budoucí funkce
                    BentoStatCard(title: "XP Dnes", value: "0", icon: "star.fill", color: .yellow)
                    BentoStatCard(title: "Série", value: "0", icon: "flame.fill", color: .red)
                }
                
                // 3. Graf (Zatím demo)
                SimpleBarChart(
                    data: [0.1, 0.2, 0.1, 0.3, 0.0, 0.0, 0.0],
                    labels: ["P", "Ú", "S", "Č", "P", "S", "N"]
                )
            }
            .padding()
        }
    }
}
