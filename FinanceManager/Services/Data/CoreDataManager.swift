//
//  CoreDataManager.swift
//  FinanceManager
//
//  Created by mp on 13.06.2025.
//

import CoreData

final class CoreDataManager: DataManaging {
    private let container = NSPersistentContainer(name: "FinanceManager")

    var context: NSManagedObjectContext {
        container.viewContext
    }

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("❌ Core Data Error: \(error.localizedDescription)")
            }
        }
    }

    func saveTransaction(transaction: Transaction) {
        save()
    }

    func removeTransaction(transaction: Transaction) {
        if let path = transaction.receiptImagePath {
            let fileURL = URL(fileURLWithPath: path)
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        context.delete(transaction)
        save()
    }

    func fetchTransactions() -> [Transaction] {
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        var transactions: [Transaction] = []
        
        do {
            transactions = try context.fetch(request)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        return transactions
    }

    func fetchTransactionById(id: UUID) -> Transaction? {
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Cannot fetch transaction by id: \(error.localizedDescription)")
            return nil
        }
    }

    
    func saveCategory(category: Category) {
            save()
        }

    func fetchCategories() -> [Category] {
        let request = NSFetchRequest<Category>(entityName: "Category")
        return (try? context.fetch(request)) ?? []
    }
    
    func removeCategory(category: Category) {
        context.delete(category)
        save()
    }
}

private extension CoreDataManager {
    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("❌ Save error: \(error.localizedDescription)")
        }
    }
}
