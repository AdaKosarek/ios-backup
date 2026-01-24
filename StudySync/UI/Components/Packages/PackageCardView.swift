//
//  ListItems.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//



import SwiftUI

struct PackageCardView: View {
    let package: StudyPackage
    
    var packageColor: Color {
        Color(hex: package.colorHex)
    }
    
    var body: some View {
        HStack(spacing: 20) { // ZVĚTŠENÍ MEZERY
            // 1. IKONA
            PremiumPathIcon(type: .folder, color: packageColor, size: 56) // Větší ikona
                // Jemný stín pod ikonou pro hloubku
                .shadow(color: packageColor.opacity(0.3), radius: 8, x: 0, y: 4)
            
            // 2. TEXTY
            VStack(alignment: .leading, spacing: 6) { // Větší řádkování
                Text(package.name)
                    .font(.title3) // Větší písmo
                    .fontWeight(.bold) // Lepší čitelnost
                    .foregroundStyle(.black)
                
                HStack(spacing: 6) {
                    Label("\(package.groups.count) skupin", systemImage: "folder.fill")
                    
                    Text("\(countCards()) karet")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // 3. ŠIPKA (V kroužku pro lepší kontrast)
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(packageColor)
                .frame(width: 32, height: 32)
                .background(packageColor.opacity(0.1)) // Podklad šipky
                .clipShape(Circle())
        }
        .padding(20) // VÍCE PROSTORU (ROZBALENÉ)
        // 4. KONTRASTNÍ POZADÍ
        .background(Color(UIColor.systemBackground)) // Čistá barva (bílá/černá)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        // Výraznější rámeček
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(packageColor.opacity(0.3), lineWidth: 1.5)
        )
        // Výraznější stín
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
    }
    
    private func countCards() -> Int {
        package.groups.reduce(0) { $0 + $1.cards.count }
    }
}
