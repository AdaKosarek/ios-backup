//
//  StudyCardRowView.swift
//  StudySync
//
//  Created by Martin Reich on 21.01.2026.
//


import SwiftUI

struct StudyCardRowView: View {
    let card: StudyCard
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) { // Alignment .top pro delší texty
            // 1. IKONA
            PremiumPathIcon(type: .doc, color: .orange, size: 44)
                .padding(.top, 2) // Malá korekce zarovnání
            
            // 2. TEXTY
            VStack(alignment: .leading, spacing: 8) { // Větší mezera mezi Q a A
                
                // Otázka (Výrazná)
                Text(card.question)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true) // Aby se text nezasekl
                
                // Oddělovač (čára)
                Divider()
                    .background(Color.orange.opacity(0.2))
                
                // Odpověď (Jemnější, kurzíva)
                Text(card.answer)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .opacity(0.75)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(UIColor.systemBackground)) // Kontrastní bílá/černá
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        )
        // Jemný stín, aby to "plavalo"
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
