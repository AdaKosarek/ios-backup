//
//  TransactionDetailViewState.swift
//  FinanceManager
//
//  Created by mp on 15.06.2025.
//
import Observation
import Foundation

@Observable
final class TransactionDetailViewState {
    var transaction: TransactionModel

    init(transaction: TransactionModel) {
        self.transaction = transaction
    }
}
