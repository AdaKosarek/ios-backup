//
//  HomeViewState.swift
//  FinanceManager
//
//  Created by mp on 12.06.2025.
//

import SwiftUI

@Observable
final class HomeViewState {
    var availablePeriods: [PeriodModel] = []
    var selectedPeriod: PeriodModel? = .allTime

    var totalIncome: Double = 0.0
    var totalExpenses: Double = 0.0
    var balance: Double = 0
}
