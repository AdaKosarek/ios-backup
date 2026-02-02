//
//  Untitled.swift
//  FinanceManager
//
//  Created by mp on 22.06.2025.
//
import SwiftUI

struct PeriodSelector<Period: Hashable & Identifiable>: View {
    let periods: [Period]
    let selectedPeriod: Period
    let onSelect: (Period) -> Void
    let title: (Period) -> String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(periods) { period in
                    Button {
                        onSelect(period)
                    } label: {
                        Text(title(period))
                            .fontWeight(selectedPeriod == period ? .semibold : .regular)
                            .foregroundColor(.primary)
                            .overlay(
                                VStack {
                                    if selectedPeriod == period {
                                        Capsule()
                                            .fill(Color.purple)
                                            .frame(height: 3)
                                            .offset(y: 10)
                                    }
                                },
                                alignment: .bottom
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
