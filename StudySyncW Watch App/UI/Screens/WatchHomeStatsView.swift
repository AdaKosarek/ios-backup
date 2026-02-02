//
//  WatchHomeStatsView.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI

struct WatchDashboardView: View {
    @State private var connector = WatchConnector.shared
    @State private var viewModel = WatchStatsViewModel()
    
    var totalCardsCount: Int {
        connector.receivedPackages.reduce(0) { pkgResult, pkg in
            pkgResult + pkg.groups.reduce(0) { grpResult, grp in
                grpResult + grp.cards.count
            }
        }
    }
    
    var allCards: [CardDTO] {
        connector.receivedPackages.flatMap { $0.groups.flatMap { $0.cards } }
    }
    
    let streak = 0
    let xp = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                if connector.receivedPackages.isEmpty {
                    emptyStateView
                }
                
                else if totalCardsCount == 0 {
                    packagesButNoCardsView
                }
                
                else {
                    dashboardContent
                }
            }
            .padding()
        }
    }
    
    var dashboardContent: some View {
        VStack(spacing: 16) {
            CircularProgressView(
                progress: 0.05,
                title: "\(totalCardsCount)",
                subtitle: "karet celkem",
                color: .brandBlue
            )
            .frame(height: 120)
            .contentTransition(.numericText())
            
            HStack(spacing: 20) {
                HStack {
                    Image(systemName: "star.fill").foregroundStyle(.yellow)
                    Text("\(viewModel.xpAll)").fontWeight(.bold)
                }
                HStack {
                    Image(systemName: "flame.fill").foregroundStyle(.red)
                    Text("\(viewModel.streakDays)").fontWeight(.bold)
                }
            }
            
            Spacer()
            
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
            
            Spacer()
        }
    }
    
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
