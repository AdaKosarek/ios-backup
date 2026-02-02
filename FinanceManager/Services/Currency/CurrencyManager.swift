//
//  CurrencyManager.swift
//  FinanceManager
//
//  Created by mp on 23.06.2025.
//

import SwiftUI

final class CurrencyManager: ObservableObject {
    @Published var currencyCode: String = "CZK"

    private let key = "defaultCurrency"

    init() {
        load()
    }

    private let exchangeRates: [String: Double] = [
            "CZK": 1.0,
            "EUR": 0.04,
            "USD": 0.045
        ]
    
    func load() {
        currencyCode = UserDefaults.standard.string(forKey: key) ?? "CZK"
    }

    func save() {
        UserDefaults.standard.set(currencyCode, forKey: key)
    }
    
    func convert(amount: Double, to targetCurrency: String) -> Double {
        let sourceRate = exchangeRates["CZK"] ?? 1.0
        let targetRate = exchangeRates[targetCurrency] ?? 1.0
        return amount / sourceRate * targetRate
    }
    
    func convertToCZK(amount: Double, from sourceCurrency: String) -> Double {
        let sourceRate = exchangeRates[sourceCurrency] ?? 1.0
        let czkRate = exchangeRates["CZK"] ?? 1.0
        return amount / sourceRate * czkRate
    }
}

