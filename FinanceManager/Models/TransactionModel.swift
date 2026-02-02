//
//  TransactionModel.swift
//  FinanceManager
//
//  Created by mp on 13.06.2025.
//

import Foundation
import UIKit

struct TransactionModel: Identifiable {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var isExpense: Bool
    var category: CategoryModel?
    var location: String?
    var receiptImage: UIImage?
}
