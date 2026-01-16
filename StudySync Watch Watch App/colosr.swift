//
//  colosr.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import SwiftUI

// MARK: - Barvy a Gradienty
extension Color {
    static let brandPurple = Color(red: 0.4, green: 0.2, blue: 0.8) // Příklad fialové
    static let brandBlue = Color(red: 0.2, green: 0.4, blue: 1.0) // Příklad modré
    static let brandDarkBg = Color(red: 0.1, green: 0.1, blue: 0.15) // Tmavé pozadí
    
    static let mainGradient = LinearGradient(
        colors: [brandBlue, brandPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Znovupoužitelné Komponenty

// 1. Kruhový Progress Bar
struct CircularProgressView: View {
    let progress: Double // 0.0 až 1.0
    let title: String
    let subtitle: String
    var color: Color = .brandBlue

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

// 2. Bento Karta pro Statistiky
struct BentoStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(color)
                Spacer()
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// 3. Sloupcový Graf (Jednoduchá implementace)
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
