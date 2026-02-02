//
//  TranscationDetailViewModel.swift
//  FinanceManager
//
//  Created by mp on 15.06.2025.
//
import SwiftUI

import Combine

final class TransactionDetailViewModel: ObservableObject {
    var state: TransactionDetailViewState
    @Published var currencyCode: String = "CZK"

    private let dataManager: DataManaging
    private let currencyManager: CurrencyManager
    private weak var overviewViewModel: OverviewViewModel?
    private var cancellables = Set<AnyCancellable>()

    init(
        transaction: TransactionModel,
        overviewViewModel: OverviewViewModel? = nil,
        currencyManager: CurrencyManager = DIContainer.shared.resolve()
    ) {
        self.state = TransactionDetailViewState(transaction: transaction)
        self.dataManager = DIContainer.shared.resolve()
        self.currencyManager = currencyManager
        self.overviewViewModel = overviewViewModel

        self.currencyCode = currencyManager.currencyCode

        currencyManager.$currencyCode
            .sink { [weak self] newCode in
                self?.currencyCode = newCode
            }
            .store(in: &cancellables)
    }

    func convertedAmount() -> Double {
        currencyManager.convert(amount: state.transaction.amount, to: currencyCode)
    }

    func deleteTransaction() {
        guard let entity = dataManager.fetchTransactionById(id: state.transaction.id) else {
            return
        }
        dataManager.removeTransaction(transaction: entity)
        overviewViewModel?.fetchTransactions()
    }
}


