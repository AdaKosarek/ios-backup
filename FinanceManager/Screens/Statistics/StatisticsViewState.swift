//
//  StatisticsViewState.swift
//  FinanceManager
//
//  Created by mp on 21.06.2025.
//

import SwiftUI


@Observable
final class StatisticsViewState {
    var availablePeriods: [PeriodModel] = []
    var selectedPeriod: PeriodModel?
    var isExpenseSelected: Bool = true
    var chartData: [SliceModel] = []
    var totalAmount: Double = 0.0
}

