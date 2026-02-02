//
//  AddCategoryView.swift
//  FinanceManager
//
//  Created by mp on 14.06.2025.
//

import SwiftUI


struct AddCategoryView: View {
    @Binding var isPresented: Bool
    var onSave: () -> Void

    @StateObject var viewModel = AddCategoryViewModel()

    private let categoryIcons = [
        "fork.knife", "cart.fill", "car.fill", "bus.fill", "fuelpump.fill",
        "airplane", "bed.double.fill", "house.fill", "heart.fill", "cross.fill",
        "gamecontroller.fill", "film.fill", "music.note", "paintbrush.fill",
        "sportscourt.fill", "sun.max.fill", "gift.fill", "creditcard.fill",
        "doc.text.fill", "basket.fill", "pawprint.fill", "book.fill",
        "briefcase.fill", "dollarsign.circle.fill", "tag.fill","banknote.fill",
        "creditcard.fill",
        "dollarsign.circle.fill",
        "gift.fill",
        "briefcase.fill",
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter category name", text: $viewModel.state.title)
                            .textInputAutocapitalization(.words)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                    }

                    //Icon Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Icon")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(categoryIcons, id: \.self) { icon in
                                    Image(systemName: icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .padding(10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    viewModel.state.selectedIcon == icon
                                                    ? Color.accentColor
                                                    : Color.gray.opacity(0.3),
                                                    lineWidth: 2
                                                )
                                                .background(
                                                    viewModel.state.selectedIcon == icon
                                                    ? Color.accentColor.opacity(0.1)
                                                    : Color.clear
                                                )
                                        )
                                        .onTapGesture {
                                            viewModel.state.selectedIcon = icon
                                        }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }

                    //Color Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        ColorPicker(
                            "Pick a color",
                            selection: $viewModel.state.selectedColor,
                            supportsOpacity: false
                        )
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        )
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("New Category")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.saveCategory(onSave: onSave) {
                            isPresented = false
                        }
                    }
                    .disabled(viewModel.state.title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}


#Preview {
    //AddCategoryView()
}
