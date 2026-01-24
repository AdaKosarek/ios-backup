//
//  SimpleBarChart.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI


struct SimpleBarChart: View {

    let data: [Int]
    let labels: [String]

    private var maxValue: Int {
        max(data.max() ?? 1, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Tento týden")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(data.indices, id: \.self) { index in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.mainGradient)
                            .frame(
                                height: CGFloat(data[index]) / CGFloat(maxValue) * 50
                            )

                        Text(labels[index])
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: 80)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
