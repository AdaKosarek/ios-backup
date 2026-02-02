//
//  NewTransactionView.swift
//  FinanceManager
//
//  Created by mp on 12.06.2025.
//

import SwiftUI
import CoreLocation
import PhotosUI

struct NewTransactionView: View {
    @Binding var isPresented: Bool
    @State var viewModel = NewTransactionViewModel()

    @State private var selectedImage: PhotosPickerItem?
    @State private var isCategoryPickerPresented = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    //type picker
                    Picker("", selection: $viewModel.state.isExpense) {
                        Text("Expense").tag(true)
                        Text("Income").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    //amount
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amount (\(viewModel.currencyCode))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack {
                            TextField("0.00", text: $viewModel.state.amount)
                                .keyboardType(.decimalPad)
                            
                            Text(viewModel.currencyCode)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal)



                    //title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Title", text: $viewModel.state.title)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    //category
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button {
                            isCategoryPickerPresented = true
                        } label: {
                            HStack {
                                if let selected = viewModel.state.selectedCategory {
                                    Label(selected.title, systemImage: selected.icon)
                                        .foregroundColor(selected.color)
                                } else {
                                    Text("Select Category")
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)

                    //date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            DatePicker(
                                "",
                                selection: $viewModel.state.date,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()

                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                        )
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            TextField("Location", text: $viewModel.state.location)

                            Spacer()

                            Button {
                                Task {
                                    await viewModel.determineCurrentLocation()
                                }
                            } label: {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    if viewModel.state.isExpense {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Receipt")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            if let image = viewModel.state.receiptImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(8)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 150)
                                    .overlay(
                                        Text("No receipt selected")
                                            .foregroundColor(.secondary)
                                    )
                            }

                            PhotosPicker("Select Receipt", selection: $selectedImage, matching: .images)
                                .onChange(of: selectedImage) {
                                    Task {
                                        if let data = try? await selectedImage?.loadTransferable(type: Data.self),
                                           let image = UIImage(data: data) {
                                            viewModel.handleImage(image)
                                        }
                                    }
                                }

                            Toggle("Autofill from receipt", isOn: $viewModel.state.autoFillEnabled)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.saveTransaction()
                        isPresented = false
                    }
                }
            }
            .sheet(isPresented: $isCategoryPickerPresented) {
                CategoryPickerView(
                    fetchCategories: {
                        viewModel.fetchCategories()
                        return viewModel.allCategories
                    },
                    onSelect: { category in
                        viewModel.state.selectedCategory = category
                    },
                    onSave: {
                        viewModel.fetchCategories()
                    },
                    onDelete: { id in
                        viewModel.deleteCategory(id)
                    }
                )
            }
        }
    }
}



#Preview {
    //NewTransactionView()
}
