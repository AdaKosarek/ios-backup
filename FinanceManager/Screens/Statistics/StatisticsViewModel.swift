//
//  StatisticsViewModel.swift
//  FinanceManager
//
//  Created by mp on 21.06.2025.
//

import SwiftUI

import Combine

final class StatisticsViewModel: ObservableObject {
    @Published var state = StatisticsViewState()
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
            .sink { [weak self] newCode in
                self?.currencyCode = newCode
                self?.fetchData()
            }
            .store(in: &cancellables)

        fetchData()
    }

    func fetchData() {
        let transactions = dataManager.fetchTransactions()

        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactions) {
            calendar.dateComponents([.year, .month], from: $0.date ?? Date())
        }

        let months = grouped.keys.compactMap { comps in
            comps.month.flatMap { m in comps.year.flatMap { y in PeriodModel.month(m, y) } }
        }.sorted { $0.date > $1.date }

        state.availablePeriods = [.allTime] + months

        if state.selectedPeriod == nil {
            state.selectedPeriod = .allTime
        }

        updateChartData(for: state.selectedPeriod ?? .allTime, transactions: transactions)
    }

    func select(period: PeriodModel) {
        state.selectedPeriod = period
        let transactions = dataManager.fetchTransactions()
        updateChartData(for: period, transactions: transactions)
    }

    private func updateChartData(for period: PeriodModel, transactions: [Transaction]) {
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

        let targetTransactions = filtered.filter { $0.isExpense == state.isExpenseSelected }

        let totalCZK = targetTransactions.map { $0.amount }.reduce(0, +)
        let totalConverted = currencyManager.convert(amount: totalCZK, to: currencyCode)
        state.totalAmount = totalConverted

        let groupedByCategory = Dictionary(grouping: targetTransactions) {
            $0.category?.id ?? CategoryModel.other.id
        }

        var slices: [SliceModel] = []

        for (_, transactions) in groupedByCategory {
            let first = transactions.first!
            let amountCZK = transactions.map { $0.amount }.reduce(0, +)
            let amountConverted = currencyManager.convert(amount: amountCZK, to: currencyCode)
            let percent = totalConverted == 0 ? 0 : amountConverted / totalConverted

            let name = first.category?.title ?? "Other"
            let icon = first.category?.icon ?? "circle"
            let colorHex = first.category?.color ?? "#808080"
            let color = Color(hex: colorHex)

            slices.append(SliceModel(
                id: UUID(),
                categoryName: name,
                icon: icon,
                color: color,
                amount: amountConverted,
                percentage: percent
            ))
        }

        state.chartData = slices.sorted { $0.amount > $1.amount }
    }
}
