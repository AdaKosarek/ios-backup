//
//  StatBadgeView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

struct StatCard: View {
    // Vstupní parametry
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // 1. Ikonka s barevným pozadím
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        color.gradient // Použijeme gradient z barvy
                    )
                    .clipShape(Circle())
                    .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
                
                Spacer()
            }
            
            // 2. Hodnoty
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(value)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText()) // Animace čísel
                    
                    Text(unit)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground)) // Jemně šedá na světlém módu
        .clipShape(RoundedRectangle(cornerRadius: 20))
        // Jemný stín pro 3D efekt
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        
        // Identifikátor pro UI testy (např. "stat_card_Streak")
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("stat_card_\(title)")
    }
}

// Náhled pro Xcode (Preview)
#Preview {
    ZStack {
        Color(UIColor.systemGroupedBackground)
        HStack {
            StatCard(
                title: "Streak",
                value: "12",
                unit: "dní",
                icon: "flame.fill",
                color: .orange
            )
            StatCard(
                title: "Přesnost",
                value: "95",
                unit: "%",
                icon: "target",
                color: .blue
            )
        }
        .padding()
    }
}
