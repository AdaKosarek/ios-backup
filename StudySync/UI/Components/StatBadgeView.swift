//
//  StatBadgeView.swift
//  StudySync
//

import SwiftUI

struct StatCard: View {
    let title: LocalizedStringKey
    let value: String
    let unit: LocalizedStringKey
    
    let iconType: CustomIconType
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
            
            RoundedRectangle(cornerRadius: 24)
                .fill(color.opacity(0.08))
            
            VStack(alignment: .leading) {
                HStack {
                    PremiumPathIcon(type: iconType, color: color, size: 48)
                    Spacer()
                }
                
                Spacer(minLength: 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Text(value)
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundStyle(Color.primary)
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Text(unit)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(color)
                            .textCase(.uppercase)
                    }
                    
                    Text(title)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .foregroundColor(.black)
                }
            }
            .padding(16)
        }
        .frame(height: 140)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(color.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}
