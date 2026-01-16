//
//  ListItems.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import SwiftUI
struct PackageCardView: View {
    let package: StudyPackage // Předpokládám, že tvůj model se jmenuje StudyPackage
    
    var body: some View {
        HStack(spacing: 16) {
            // 1. Ikonka
            Image(systemName: package.icon)
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                // Pokud nemáš extension Color(hex:), použij fallback nebo svou implementaci
                .background(Color(hex: package.colorHex).gradient)
                .clipShape(Circle())
                .shadow(color: Color(hex: package.colorHex).opacity(0.4), radius: 4, x: 0, y: 3)
            
            // 2. Texty
            VStack(alignment: .leading, spacing: 4) {
                Text(package.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text("\(package.groups.count) skupin")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // 3. Šipka navigace
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        // Použijeme barvu, která se přizpůsobí Dark Mode
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        // Jemný stín pro efekt "vznášení"
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}
