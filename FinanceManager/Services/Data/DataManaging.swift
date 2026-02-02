//
//  DataManaging.swift
//  FinanceManager
//
//  Created by mp on 13.06.2025.
//

import CoreData

protocol DataManaging {
    var context: NSManagedObjectContext { get }

    func saveTransaction(transaction: Transaction)
    func removeTransaction(transaction: Transaction)
    func fetchTransactions() -> [Transaction]
    func fetchTransactionById(id: UUID) -> Transaction?
    
    func saveCategory(category: Category)
    func fetchCategories() -> [Category]
    func removeCategory(category: Category)
}
