//
//  PeriodModel.swift
//  FinanceManager
//
//  Created by mp on 20.06.2025.
//

import SwiftUI

enum PeriodModel: Equatable, Hashable, Identifiable {
    var id: String {
        switch self {
        case .month(let m, let y):
            return "month-\(y)-\(m)"
        case .allTime:
            return "allTime"
        }
    }
    case month(Int, Int) //month, year
    case allTime

    var title: String {
        switch self {
        case .month(let m, let y):
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let date = Calendar.current.date(from: DateComponents(year: y, month: m)) ?? Date()
            return formatter.string(from: date)
        case .allTime:
            return "All Time"
        }
    }

    var date: Date {
        switch self {
        case .month(let m, let y):
            return Calendar.current.date(from: DateComponents(year: y, month: m)) ?? Date()
        case .allTime:
            return Date.distantPast
        }
    }
}
