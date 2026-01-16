//
//  WatchContentView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//


import SwiftUI

struct WatchContentView: View {
    var body: some View {
        TabView {
            WatchDashboardView()
            WatchStatsView()
            WatchSettingsView()
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
    }
}

// MARK: - DASHBOARD (Hlavní obrazovka)

struct WatchDashboardView: View {
    // Používáme singleton, který drží data a komunikaci
    @State private var connector = WatchConnector.shared
    
    // Vypočítané vlastnosti
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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                // Grafika (Kruh)
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: 0.75)
                        .stroke(
                            LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                    
                    Image(systemName: "book.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .padding(.top, 15)
                
                // Text s počtem
                Text("\(totalCardsCount) cards")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Spacer()

                // Stavová logika
                if connector.receivedPackages.isEmpty {
                    Text("Otevři aplikaci na iPhone pro synchronizaci")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    NavigationLink(destination: WatchSessionView(cards: allCards, connector: connector)) {
                        HStack {
                            Text("Start Session")
                            Spacer()
                            Image(systemName: "play.fill")
                        }
                    }
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .padding(.bottom)
                }
            }
            .padding()
        }
    }
}

// MARK: - 2. OBRAZOVKA: STATISTIKY (Zelené/Červené boxy)
struct WatchStatsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Today's Success")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.top, 5)
                
                // Zelený box (Správně)
                HStack {
                    VStack(alignment: .leading) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.title3)
                        Text("Correct")
                            .font(.system(size: 10))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Text("18")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
                .padding()
                .background(Color.green.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Červený box (Špatně)
                HStack {
                    VStack(alignment: .leading) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                            .font(.title3)
                        Text("Incorrect")
                            .font(.system(size: 10))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Text("12")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                }
                .padding()
                .background(Color.red.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - 3. OBRAZOVKA: NASTAVENÍ (Sync)
struct WatchSettingsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text("Settings")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.top, 5)
                
                // Sync Status
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Synced")
                        }
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                        
                        Text("Just now")
                            .font(.system(size: 9))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Tlačítko Force Sync
                Button(action: { /* Fake sync */ }) {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("Force Sync")
                    }
                    .font(.caption2)
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                
                // Tlačítko Reset
                Button(action: { /* Fake reset */ }) {
                    Text("Reset Data")
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    WatchContentView()
}
