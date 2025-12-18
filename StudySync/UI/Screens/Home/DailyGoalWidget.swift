//
//  DailyGoalWidget.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

struct DailyGoalWidget: View {
    var cardsStudiedToday: Int
    var dailyGoal: Int = 20 // Cíl je třeba 20 karet denně
    
    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(Double(cardsStudiedToday) / Double(dailyGoal), 1.0)
    }
    
    var body: some View {
        ZStack {
            // Pozadí widgetu
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.gradient) // Použijeme systémovou modrou
                .shadow(radius: 5)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Dnešní pokrok")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("\(cardsStudiedToday) / \(dailyGoal)")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("karet naučeno")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Button("Start Session") {
                        // Tady by mohlo být rychlé spuštění,
                        // zatím to necháme jen jako vizuál
                    }
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .controlSize(.small)
                }
                .padding()
                
                Spacer()
                
                // Kruhový graf
                ZStack {
                    // Podklad kruhu
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 10)
                    
                    // Progress kruh
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90)) // Aby začínal nahoře
                        .animation(.easeOut, value: progress)
                    
                    // Procenta uprostřed
                    Text("\(Int(progress * 100))%")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.white)
                }
                .frame(width: 100, height: 100)
                .padding()
            }
        }
        .frame(height: 160)
    }
}

#Preview {
    DailyGoalWidget(cardsStudiedToday: 12)
        .padding()
}
