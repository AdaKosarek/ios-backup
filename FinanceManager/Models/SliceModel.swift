//
//  ExpenseSlice.swift
//  FinanceManager
//
//  Created by mp on 23.06.2025.
//

import SwiftUI

struct SliceModel: Identifiable {
    let id: UUID
    let categoryName: String
    let icon: String
    let color: Color
    let amount: Double
    let percentage: Double

    var percentageString: String {
        String(format: "%.1f%%", percentage * 100)
    }
}
