//
//  CustomBarChartView.swift
//  StudySync
//
//  Created by Martin Reich on 21.01.2026.
//

import SwiftUI

struct DailyStat: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

struct CustomBarChartView: View {
    let data: [DailyStat]
    let maxCount: Int = 20
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            ForEach(data) { item in
                VStack {
                    Text("\(item.count)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.blue.gradient)
                        .frame(width: 30, height: CGFloat(item.count) / CGFloat(maxCount) * 150)
                    
                    Text(item.day)
                        .font(.caption)
                        .bold()
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
    }
}

#Preview {
    CustomBarChartView(data: [
        DailyStat(day: "Po", count: 5),
        DailyStat(day: "Út", count: 12),
        DailyStat(day: "St", count: 8),
        DailyStat(day: "Čt", count: 15),
        DailyStat(day: "Pá", count: 2)
    ])
}
