//
//  DailyGoalWidget.swift
//  StudySync
//

import SwiftUI

struct DailyGoalWidget: View {
    var cardsStudiedToday: Int
    var dailyGoal: Int = 20
    
    // Barvy pro tento widget (Modro-fialová)
    private let gradientColors = [Color.blue, Color.purple]
    
    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(Double(cardsStudiedToday) / Double(dailyGoal), 1.0)
    }
    
    var body: some View {
        ZStack {
            // 1. VRSTVA: Pevné pozadí
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
            
            // 2. VRSTVA: Jemný barevný nádech
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.1), // Ještě jemnější
                            Color.purple.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // 3. VRSTVA: Vodotisk (OPRAVENO: Posunuto doleva a zprůhledněno)
            GeometryReader { proxy in
                Image(systemName: "target")
                    .font(.system(size: 100))
                    .foregroundStyle(
                        LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom)
                    )
                    .opacity(0.05) // ZMĚNA: Jen 5% průhlednost (velmi jemné)
                    .rotationEffect(.degrees(-15))
                    // ZMĚNA: Posunuto doleva (-proxy...), aby to nebylo pod grafem
                    .offset(x: -proxy.size.width * 0.1, y: proxy.size.height * 0.2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            // 4. VRSTVA: Obsah
            HStack(spacing: 20) {
                // LEVÁ ČÁST: Texty (Ty budou nad vodotiskem, což nevadí)
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "flag.fill")
                            .foregroundStyle(.purple)
                        Text("Dnešní cíl")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(cardsStudiedToday)")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(.primary)
                            .contentTransition(.numericText())
                        
                        Text("/ \(dailyGoal)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityIdentifier("dailyGoalRatioText")
                    
                    if cardsStudiedToday >= dailyGoal {
                        Label("Splněno!", systemImage: "checkmark.seal.fill")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                            .padding(.top, 4)
                    } else {
                        Text("Jen tak dál!")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                }
                
                Spacer()
                
                // PRAVÁ ČÁST: Kruhový graf (Tady už pozadí bude čisté)
                ZStack {
                    // Pozadí kruhu
                    Circle()
                        .stroke(Color.primary.opacity(0.1), lineWidth: 12)
                    
                    // Progress
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .shadow(color: .blue.opacity(0.3), radius: 5)
                        .animation(.easeOut(duration: 0.8), value: progress)
                    
                    // Procenta uprostřed
                    VStack(spacing: 0) {
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                            .contentTransition(.numericText())
                            .accessibilityIdentifier("dailyGoalPercentageText")
                    }
                }
                .frame(width: 85, height: 85)
            }
            .padding(24)
        }
        .frame(height: 150)
        
        // 5. VRSTVA: Rámeček
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(
                    LinearGradient(
                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        // Stín celé karty
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
        
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("dailyGoalWidget")
    }
}
