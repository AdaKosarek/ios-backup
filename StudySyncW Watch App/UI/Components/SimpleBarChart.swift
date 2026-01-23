//
//  SimpleBarChart.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI


struct SimpleBarChart: View {
    let data: [Double] // Hodnoty pro sloupc
    let labels: [String] // Popisky (např. dny v týdnu)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<data.count, id: \.self) { index in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.mainGradient)
                            .frame(height: CGFloat(data[index] * 50)) // Výška podle hodnoty
                        
                        Text(labels[index])
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: 80)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
