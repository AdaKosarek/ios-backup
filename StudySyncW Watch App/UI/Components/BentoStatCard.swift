//
//  BentoStatCard.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI


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
