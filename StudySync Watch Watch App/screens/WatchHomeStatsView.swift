//
//  WatchHomeStatsView.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

import SwiftUI

struct WatchDashboardView: View {
    @State private var connector = WatchConnector.shared
    
    // Spočítáme skutečný počet karet
    var totalCardsCount: Int {
        connector.receivedPackages.reduce(0) { pkgResult, pkg in
            pkgResult + pkg.groups.reduce(0) { grpResult, grp in
                grpResult + grp.cards.count
            }
        }
    }
    
    // Helper: Všechny karty v jednom poli
    var allCards: [CardDTO] {
        connector.receivedPackages.flatMap { $0.groups.flatMap { $0.cards } }
    }
    
    let streak = 0
    let xp = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // STAV 1: ÚPLNĚ BEZ DAT (Žádné balíčky)
                if connector.receivedPackages.isEmpty {
                    emptyStateView
                }
                
                // STAV 2: MÁME BALÍČKY, ALE JSOU PRÁZNÉ (0 karet)
                else if totalCardsCount == 0 {
                    packagesButNoCardsView
                }
                
                // STAV 3: MÁME KARTY -> MŮŽEME SE UČIT
                else {
                    dashboardContent
                }
            }
            .padding()
        }
    }
    
    // MARK: - Subviews
    
    // 1. Obsah Dashboardu (když je vše OK)
    var dashboardContent: some View {
        VStack(spacing: 16) {
            // Kruh
            CircularProgressView(
                progress: 0.05,
                title: "\(totalCardsCount)",
                subtitle: "karet celkem",
                color: .brandBlue
            )
            .frame(height: 120)
            .contentTransition(.numericText())
            
            // Statistiky
            HStack(spacing: 20) {
                HStack {
                    Image(systemName: "flame.fill").foregroundStyle(.orange)
                    Text("\(streak)").fontWeight(.bold)
                }
                HStack {
                    Image(systemName: "star.fill").foregroundStyle(.yellow)
                    Text("\(xp)").fontWeight(.bold)
                }
            }
            
            Spacer()
            
            // TLAČÍTKO START - Tady posíláme karty!
            NavigationLink(destination: WatchSessionView(cards: allCards)) {
                Text("Spustit učení >")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.mainGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .buttonStyle(.plain)
        }
    }
    
    // 2. Úplně prázdno
    var emptyStateView: some View {
        VStack {
            Spacer()
            Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                .font(.largeTitle)
                .foregroundStyle(.gray)
                .padding(.bottom, 8)
            
            Text("Žádná data")
                .font(.headline)
            
            Text("Otevři iPhone aplikaci a synchronizuj balíčky.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { withAnimation { connector.generateMockData() } }) {
                Text("Nahrát Demo Data")
                    .fontWeight(.bold)
            }
            .tint(.orange)
            .padding(.top)
            Spacer()
        }
    }
    
    // 3. Balíčky jsou, ale karty ne
    var packagesButNoCardsView: some View {
        VStack {
            Spacer()
            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundStyle(.orange)
                .padding(.bottom, 8)
            
            Text("Prázdné balíčky")
                .font(.headline)
            
            Text("Máš balíčky, ale nejsou v nich žádné kartičky.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            // I tady nabídneme Demo data, abys to mohl otestovat
            Button(action: { withAnimation { connector.generateMockData() } }) {
                Text("Přidat Demo Karty")
                    .fontWeight(.bold)
            }
            .tint(.blue)
            .padding(.top)
            Spacer()
        }
    }
}
