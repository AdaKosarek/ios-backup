//
//  WatchContentView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//


import SwiftUI
import SwiftData

struct WatchContentView: View {
    // Toto je hlavní kontejner, který umožňuje swipování
    var body: some View {
        TabView {
            // 1. Stránka: Hlavní přehled (Dashboard)
            WatchDashboardView()
            
            // 2. Stránka: Statistiky (Stats)
            WatchStatsView()
            
            // 3. Stránka: Nastavení (Settings)
            WatchSettingsView()
        }
        .tabViewStyle(.page) // Důležité: Toto zapne styl "teček" dole a swipování
        .ignoresSafeArea()
    }
}

// MARK: - 1. OBRAZOVKA: DASHBOARD (Tvůj původní kód)
struct WatchDashboardView: View {
    let cardsLeft = 4
    let streak = 12
    let xp = 90
    
    // Demo karty pro session
    let demoCards = [
        StudyCard(question: "What is the capital of France?", answer: "Paris"),
        StudyCard(question: "H2O stands for?", answer: "Water"),
        StudyCard(question: "2 + 2 = ?", answer: "4")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                // Kruhový graf
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 80, height: 80) // Trochu zmenšeno kvůli tečkám dole
                    
                    Circle()
                        .trim(from: 0, to: 0.75)
                        .stroke(
                            LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 0) {
                        Text("\(cardsLeft)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("left")
                            .font(.system(size: 9))
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.top, 15)
                
                // Statistiky (Streak & XP)
                HStack(spacing: 15) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("\(streak)")
                            .fontWeight(.bold)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .foregroundStyle(.yellow)
                        Text("\(xp)")
                            .fontWeight(.bold)
                    }
                }
                .font(.caption2)
                
                Spacer()
                
                // Tlačítko Start
                NavigationLink(destination: WatchSessionView(cards: demoCards)) {
                    HStack {
                        Text("Start Session")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.footnote)
                    .fontWeight(.semibold)
                }
                .background(
                    LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
                .padding(.bottom, 10) // Místo pro tečky stránkování
            }
            .padding(.horizontal)
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
