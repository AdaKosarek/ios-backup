//
//  OverviewViewState.swift
//  FinanceManager
//
//  Created by mp on 14.06.2025.
//

import Observation
import SwiftUI

@Observable
final class OverviewViewState {
    var groupedTransactions: [Date: [TransactionModel]] = [:]
}
