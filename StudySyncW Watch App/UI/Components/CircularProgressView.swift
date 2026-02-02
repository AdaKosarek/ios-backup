//
//  CircularProgressView.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI


struct CircularProgressView: View {
    let progress: Double
    let title: String
    let subtitle: String
    var color: Color = .brandBlue

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}
