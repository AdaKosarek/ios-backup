//
//  ListItems.swift
//  StudySync
//
//  Created by mp on 16.01.2026.
//

import SwiftUI

struct PackageCardView: View {
    let package: StudyPackage
    
    var packageColor: Color {
        Color(hex: package.colorHex)
    }
    
    var body: some View {
        HStack(spacing: 20) {
            PremiumPathIcon(type: .folder, color: packageColor, size: 56)
                .shadow(color: packageColor.opacity(0.3), radius: 8, x: 0, y: 4)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(package.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                
                HStack(spacing: 6) {
                    Label("\(package.groups.count) skupin", systemImage: "folder.fill")
                        .foregroundStyle(Color.black.opacity(0.75))
                    Text("\(countCards()) karet")
                        .foregroundStyle(Color.black.opacity(0.75))
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(packageColor)
                .frame(width: 32, height: 32)
                .background(packageColor.opacity(0.1))
                .clipShape(Circle())
        }
        .padding(20)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(packageColor.opacity(0.3), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
    }
    
    private func countCards() -> Int {
        package.groups.reduce(0) { $0 + $1.cards.count }
    }
}
