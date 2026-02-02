//
//  TransactionDetailView.swift
//  FinanceManager
//
//  Created by mp on 15.06.2025.
//

import SwiftUI

struct TransactionDetailView: View {
    @State private var viewModel: TransactionDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false
    @State private var showImageSheet = false

    init(viewModel: TransactionDetailViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let category = viewModel.state.transaction.category {
                    Label {
                        Text(category.title)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: category.icon)
                            .foregroundColor(category.color)
                            .font(.title)
                    }
                }

                Text(viewModel.state.transaction.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text("\(viewModel.state.transaction.isExpense ? "-" : "+")\(viewModel.convertedAmount(), format: .currency(code: viewModel.currencyCode))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(viewModel.state.transaction.isExpense ? .primary : .purple)

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Date", systemImage: "calendar")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(viewModel.state.transaction.date, style: .date)
                            .foregroundColor(.primary)
                    }

                    if let location = viewModel.state.transaction.location, !location.isEmpty {
                        HStack {
                            Label("Location", systemImage: "mappin.and.ellipse")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(location)
                                .foregroundColor(.primary)
                        }
                    }

                    if let image = viewModel.state.transaction.receiptImage {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Receipt", systemImage: "doc.text.viewfinder")
                                .foregroundColor(.secondary)

                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 250)
                                .cornerRadius(10)
                                .shadow(radius: 4)
                                .onTapGesture {
                                    showImageSheet = true
                                }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .confirmationDialog(
            "Are you sure you want to delete this transaction?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deleteTransaction()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .sheet(isPresented: $showImageSheet) {
            if let image = viewModel.state.transaction.receiptImage {
                ZStack {
                    Color.black.ignoresSafeArea()

                    VStack {
                        Spacer()

                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()

                        Spacer()
                    }

                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                showImageSheet = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .shadow(radius: 4)
                            }
                            .padding()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}



