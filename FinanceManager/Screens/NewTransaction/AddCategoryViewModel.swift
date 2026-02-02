//
//  AddCategoryViewModel.swift
//  FinanceManager
//
//  Created by mp on 14.06.2025.
//

import SwiftUI

final class AddCategoryViewModel: ObservableObject {
    @Published var state = AddCategoryViewState()
    private var dataManager: DataManaging

    init() {
        dataManager = DIContainer.shared.resolve()
    }

    func saveCategory(onSave: () -> Void, dismiss: () -> Void) {
        let category = Category(context: dataManager.context)
        category.id = UUID()
        category.title = state.title.trimmingCharacters(in: .whitespaces)
        category.icon = state.selectedIcon
        category.color = state.selectedColor.toHex() ?? "#000000"
        dataManager.saveCategory(category: category)
        onSave()
        dismiss()
    }
}

