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
            PremiumPathIcon(type: .layers, color: themeColor, size: 50)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(group.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                
                Text("\(group.cards.count) otázek")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(themeColor.gradient)
                    .clipShape(Capsule())
                    .shadow(color: themeColor.opacity(0.3), radius: 2, y: 1)
            }
            
            Spacer()
            
            Image(systemName: "play.fill")
                .font(.subheadline)
                .foregroundStyle(themeColor)
                .frame(width: 36, height: 36)
                .background(themeColor.opacity(0.1))
                .clipShape(Circle())
        }
        .padding(18)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(themeColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}
