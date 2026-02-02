//  Overview.swift
//  FinanceManager
//
//  Created by mp on 13.06.2025.
//

import SwiftUI

struct OverviewView: View {
    @Binding var isSheetPresented: Bool
    @StateObject private var viewModel = OverviewViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                        let transactions = viewModel.groupedTransactions[date] ?? []

                        HStack {
                            Text(date, style: .date)
                                .foregroundColor(.secondary)
                                .font(.subheadline)

                            Spacer()

                            let dailyTotalCZK = transactions.reduce(0.0) {
                                $0 + ($1.isExpense ? -$1.amount : $1.amount)
                            }
                            let dailyTotalConverted = viewModel.convert(amount: dailyTotalCZK)

                            Text(dailyTotalConverted, format: .currency(code: viewModel.currencyCode))
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 3)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.secondary.opacity(0.1))
                                )
                        }
                        .padding(.horizontal)
                        .padding(.top, 24.0)
                        .padding(.bottom, 8.0)

                        Divider()
                            .padding(.horizontal, 16)

                        ForEach(transactions) { transaction in
                            NavigationLink {
                                TransactionDetailView(
                                    viewModel: TransactionDetailViewModel(
                                        transaction: transaction,
                                        overviewViewModel: viewModel
                                    )
                                )
                            } label: {
                                HStack(spacing: 12) {
                                    if let category = transaction.category {
                                        Image(systemName: category.icon)
                                            .foregroundColor(category.color)
                                            .frame(width: 24, height: 24)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.purple)
                                            .frame(width: 24, height: 24)
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(transaction.title)
                                            .font(.body)
                                            .foregroundColor(.primary)

                                        if let category = transaction.category {
                                            Text(category.title)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }

                                    Spacer()

                                    let amount = viewModel.convert(amount: transaction.amount)
                                    Text("\(transaction.isExpense ? "-" : "")\(amount, format: .currency(code: viewModel.currencyCode))")
                                        .font(.body)
                                        .foregroundColor(transaction.isExpense ? .primary : Color(red: 75/255, green: 0/255, blue: 130/255))
                                }
                                .padding(.horizontal)
                                .frame(height: 52)
                            }

                            Divider()
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchTransactions()
            }
            .onChange(of: isSheetPresented) { newValue in
                if !newValue {
                    viewModel.fetchTransactions()
                }
            }
        }
    }
}







#Preview {
    //OverviewView()
}
