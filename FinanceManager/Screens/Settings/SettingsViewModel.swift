//
//  SettingsViewModel.swift
//  FinanceManager
//
//  Created by mp on 23.06.2025.
//

import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var currencyCode: String

    private let currencyManager: CurrencyManager

    init(currencyManager: CurrencyManager = DIContainer.shared.resolve()) {
        self.currencyManager = currencyManager
        self.currencyCode = currencyManager.currencyCode
    }

    func updateCurrency(_ newCurrency: String) {
        currencyManager.currencyCode = newCurrency
        currencyManager.save()
    }
}
