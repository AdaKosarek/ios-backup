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
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.25))

            RoundedRectangle(cornerRadius: 18)
                .fill(color.opacity(0.18))

            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.35),
                            .white.opacity(0.05),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )

            VStack(alignment: .leading, spacing: 8) {

                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(color)
                        .frame(width: 26, height: 26)
                        .background(
                            Circle()
                                .fill(color.opacity(0.25))
                        )

                    Spacer()

                    Text(value)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(12)
        }
        .frame(height: 72)
    }
}

