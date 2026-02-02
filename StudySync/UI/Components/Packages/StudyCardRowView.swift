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
        HStack(alignment: .top, spacing: 16) {
            PremiumPathIcon(type: .doc, color: Color.black.opacity(0.75), size: 44)
                .padding(.top, 2)
                .foregroundStyle(.black)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(card.question)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                    .background(Color.orange.opacity(0.2))
                
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
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
