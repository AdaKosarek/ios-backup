//
//  CategoryPickerView.swift
//  FinanceManager
//
//  Created by mp on 14.06.2025.
//

import SwiftUI

struct CategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss

    let fetchCategories: () -> [CategoryModel]
    var onSelect: (CategoryModel) -> Void
    var onSave: () -> Void
    var onDelete: (UUID) -> Void

    @State private var categories: [CategoryModel] = []
    @State private var selectedCategoryID: UUID?
    @State private var isAddCategoryPresented = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                List {
                    ForEach(categories) { category in
                        HStack {
                            Label(category.title, systemImage: category.icon)
                                .foregroundColor(category.color)
                            Spacer()
                            if category.id == selectedCategoryID {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCategoryID = category.id
                        }
                    }
                    .onDelete(perform: deleteCategory)
                }
                .listStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 16) // ✅ Odsazení zleva i zprava
            }
            .padding(.top, 12)
            .navigationTitle("Select Category")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let chosen = categories.first(where: { $0.id == selectedCategoryID }) {
                            onSelect(chosen)
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddCategoryPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddCategoryPresented) {
                AddCategoryView(isPresented: $isAddCategoryPresented) {
                    onSave()
                    categories = fetchCategories()
                }
            }
            .onAppear {
                categories = fetchCategories()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }

    private func deleteCategory(at offsets: IndexSet) {
        for index in offsets {
            let id = categories[index].id
            onDelete(id)
        }
        categories = fetchCategories()
    }
}



#Preview {
    //CategoryPickerView()
}
