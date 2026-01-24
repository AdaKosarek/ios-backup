//
//  GroupCardView.swift
//  StudySync
//
//  Created by Martin Reich on 21.01.2026.
//


import SwiftUI

struct GroupCardView: View {
    let group: StudyGroup
    let themeColorHex: String
    
    var themeColor: Color {
        Color(hex: themeColorHex)
    }
    
    var body: some View {
        HStack(spacing: 18) {
            // 1. IKONA
            PremiumPathIcon(type: .layers, color: themeColor, size: 50)
            
            // 2. TEXTY
            VStack(alignment: .leading, spacing: 6) {
                Text(group.name)
                    .font(.headline) // Výraznější
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                
                // KONTRASTNÍ ŠTÍTEK
                Text("\(group.cards.count) otázek")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white) // Bílý text
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(themeColor.gradient) // Barevné pozadí
                    .clipShape(Capsule())
                    .shadow(color: themeColor.opacity(0.3), radius: 2, y: 1)
            }
            
            Spacer()
            
            // 3. TLAČÍTKO PLAY
            Image(systemName: "play.fill")
                .font(.subheadline)
                .foregroundStyle(themeColor)
                .frame(width: 36, height: 36)
                .background(themeColor.opacity(0.1)) // Jemné pozadí tlačítka
                .clipShape(Circle())
        }
        .padding(18) // Vzdušnější padding
        .background(Color(UIColor.systemBackground)) // Kontrastní pozadí
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(themeColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}
