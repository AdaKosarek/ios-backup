//
//  OverviewViewModel.swift
//  FinanceManager
//
//  Created by mp on 14.06.2025.
//

import SwiftUI

import Combine

final class OverviewViewModel: ObservableObject {
    @Published var groupedTransactions: [Date: [TransactionModel]] = [:]
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
                self?.fetchTransactions()
            }
            .store(in: &cancellables)

        fetchTransactions()
    }

    func fetchTransactions() {
        let entities = dataManager.fetchTransactions()

        let transactions = entities.map {
            TransactionModel(
                id: $0.id ?? UUID(),
                title: $0.title ?? "",
                amount: $0.amount,
                date: $0.date ?? Date(),
                isExpense: $0.isExpense,
                category: $0.category.map {
                    CategoryModel(
                        id: $0.id ?? UUID(),
                        title: $0.title ?? "",
                        icon: $0.icon ?? "questionmark",
                        color: Color(hex: $0.color ?? "#000000")
                    )
                },
                location: $0.location,
                receiptImage: loadReceiptImage(filename: $0.receiptImagePath)
            )
        }

        let grouped = Dictionary(grouping: transactions) {
            Calendar.current.startOfDay(for: $0.date)
        }

        groupedTransactions = grouped
    }

    func convert(amount: Double) -> Double {
        currencyManager.convert(amount: amount, to: currencyCode)
    }

    private func loadReceiptImage(filename: String?) -> UIImage? {
        guard let filename else { return nil }
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(filename)
        return UIImage(contentsOfFile: fileURL.path)
    }
}
