//
//  HomeViewModel.swift
//  FinanceManager
//
//  Created by mp on 12.06.2025.
//

import SwiftUI
import Combine


final class HomeViewModel: ObservableObject {
    @Published var state = HomeViewState()
    @Published var currencyCode: String = "CZK"

    private var dataManager: DataManaging
    private var currencyManager: CurrencyManager
    private var cancellables = Set<AnyCancellable>()

    init(
        dataManager: DataManaging = DIContainer.shared.resolve(),
        currencyManager: CurrencyManager = DIContainer.shared.resolve()
    ) {
        self.dataManager = dataManager
        self.currencyManager = currencyManager

        self.currencyCode = currencyManager.currencyCode

        currencyManager.$currencyCode
            .sink { [weak self] newCurrency in
                self?.currencyCode = newCurrency
                self?.fetchData() // ⚡️ Přepočítej znovu při změně měny!
            }
            .store(in: &cancellables)

        fetchData()
    }

    func fetchData() {
        let transactions = dataManager.fetchTransactions()

        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactions) { transaction in
            calendar.dateComponents([.year, .month], from: transaction.date ?? Date())
        }

        let months = grouped.keys.compactMap { comps in
            comps.month.flatMap { month in
                comps.year.flatMap { year in
                    PeriodModel.month(month, year)
                }
            }
        }.sorted { $0.date > $1.date }

        state.availablePeriods = [.allTime] + months

        if state.selectedPeriod == nil {
            state.selectedPeriod = .allTime
        }

        updateValues(for: state.selectedPeriod ?? .allTime, transactions: transactions)
    }

    func select(period: PeriodModel) {
        state.selectedPeriod = period
        let transactions = dataManager.fetchTransactions()
        updateValues(for: period, transactions: transactions)
    }

    private func updateValues(for period: PeriodModel, transactions: [Transaction]) {
        let filtered: [Transaction]

        switch period {
        case .allTime:
            filtered = transactions
        case .month(let m, let y):
            filtered = transactions.filter {
                let comps = Calendar.current.dateComponents([.year, .month], from: $0.date ?? Date())
                return comps.month == m && comps.year == y
            }
        }

        let incomeCZK = filtered.filter { !$0.isExpense }.map { $0.amount }.reduce(0, +)
        let expensesCZK = filtered.filter { $0.isExpense }.map { $0.amount }.reduce(0, +)

        let income = currencyManager.convert(amount: incomeCZK, to: currencyCode)
        let expenses = currencyManager.convert(amount: expensesCZK, to: currencyCode)

        state.totalIncome = income
        state.totalExpenses = expenses
        state.balance = income - expenses
    }
}
