//
//  WatchHomeStatsView.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

//
//  HomeStatsView.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

import SwiftUI

struct HomeStatsView: View {
    // Tmavé pozadí aplikace
    let bgDark = Color(red: 0.05, green: 0.07, blue: 0.12)
    let cardBg = Color(red: 0.1, green: 0.12, blue: 0.18)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("Today's Stats")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .padding(.top)
                    
                    // --- 1. KRUHOVÝ GRAF (ACCURACY) ---
                    ZStack {
                        // Podkladový kruh
                        Circle()
                            .stroke(Color.gray.opacity(0.15), lineWidth: 15)
                            .frame(width: 160, height: 160)
                        
                        // Barevný kruh (87%)
                        Circle()
                            .trim(from: 0, to: 0.87)
                            .stroke(
                                LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom),
                                style: StrokeStyle(lineWidth: 15, lineCap: .round)
                            )
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(-90))
                            .shadow(color: .green.opacity(0.3), radius: 10)
                        
                        // Text uvnitř
                        VStack {
                            Text("87%")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text("Accuracy")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    // --- 2. BAREVNÉ KARTIČKY (XP, CARDS, TIMER) ---
                    VStack(spacing: 15) {
                        // XP Earned (Hnědá/Zlatá)
                        StatCard(
                            icon: "bolt.fill",
                            color: .orange,
                            title: "XP Earned",
                            subtitle: "Today",
                            value: "5",
                            gradientColors: [Color.orange.opacity(0.2), Color.brown.opacity(0.2)]
                        )
                        
                        // Cards Done (Modrá)
                        StatCard(
                            icon: "chart.bar.fill",
                            color: .blue,
                            title: "Cards Done",
                            subtitle: "Today",
                            value: "15",
                            gradientColors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]
                        )
                        
                        // Next Session (Fialová)
                        StatCard(
                            icon: "clock.fill",
                            color: .purple,
                            title: "Next Session",
                            subtitle: "Timer",
                            value: "2h",
                            gradientColors: [Color.purple.opacity(0.2), Color.pink.opacity(0.2)]
                        )
                    }
                    .padding(.horizontal)
                    
                    // --- 3. GRAF (THIS WEEK) ---
                    VStack(alignment: .leading, spacing: 15) {
                        Text("This Week")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        HStack(alignment: .bottom, spacing: 12) {
                            // Falešná data pro graf, aby vypadal jako na obrázku
                            let heights: [CGFloat] = [30, 40, 35, 70, 50, 80, 40]
                            let days = ["M", "T", "W", "T", "F", "S", "S"]
                            
                            ForEach(0..<7) { index in
                                VStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .bottom, endPoint: .top))
                                        .frame(height: heights[index])
                                    
                                    Text(days[index])
                                        .font(.system(size: 10))
                                        .foregroundStyle(.gray)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding()
                    // Pozadí grafu zmizí do ztracena (gradient)
                    .background(
                        LinearGradient(colors: [cardBg, bgDark], startPoint: .top, endPoint: .bottom)
                    )
                    .padding(.horizontal)
                    
                    Spacer(minLength: 80) // Místo dole pro tab bar
                }
            }
        }
    }
}

// Pomocná komponenta pro řádek statistiky
struct StatCard: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    let value: String
    let gradientColors: [Color]
    
    var body: some View {
        HStack {
            // Ikonka
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundStyle(color)
            }
            
            // Texty
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            // Hodnota
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
        .padding()
        .background(LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeStatsView()
}
