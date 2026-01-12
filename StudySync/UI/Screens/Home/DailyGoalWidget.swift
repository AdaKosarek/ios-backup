//
//  DailyGoalWidget.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

struct DailyGoalWidget: View {
    var cardsStudiedToday: Int
    var dailyGoal: Int = 20
    
    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(Double(cardsStudiedToday) / Double(dailyGoal), 1.0)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.gradient)
                .shadow(radius: 5)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Dnešní pokrok")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("\(cardsStudiedToday) / \(dailyGoal)")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("dailyGoalRatioText") // ID pro poměr
                    
                    Text("karet naučeno")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Button("Start Session") { }
                        .buttonStyle(.bordered)
                        .tint(.white)
                        .controlSize(.small)
                        .accessibilityIdentifier("startSessionWidgetButton") // ID pro tlačítko
                }
                .padding()
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 10)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut, value: progress)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("dailyGoalPercentageText") // ID pro procenta
                }
                .frame(width: 100, height: 100)
                .padding()
            }
        }
        .frame(height: 160)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("dailyGoalWidget") // KLÍČOVÝ IDENTIFIKÁTOR
    }
}
