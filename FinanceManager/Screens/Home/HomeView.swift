//
//  HomeView.swift
//  FinanceManager
//
//  Created by mp on 12.06.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Binding var isSheetPresented: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PeriodSelector(
                    periods: viewModel.state.availablePeriods,
                    selectedPeriod: viewModel.state.selectedPeriod ?? viewModel.state.availablePeriods.first!,
                    onSelect: viewModel.select,
                    title: { $0.title }
                )

                Divider().padding(.horizontal, 16)

                HStack {
                    VStack {
                        Text("Income")
                            .foregroundColor(.secondary)
                        Text(viewModel.state.totalIncome, format: .currency(code: viewModel.currencyCode))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                    }
                    .frame(maxWidth: .infinity)

                    Divider()

                    VStack {
                        Text("Expenses")
                            .foregroundColor(.secondary)
                        Text(viewModel.state.totalExpenses, format: .currency(code: viewModel.currencyCode))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                .padding(.horizontal)

                VStack(spacing: 4) {
                    Text("Balance")
                        .foregroundColor(.secondary)
                    Text(viewModel.state.balance, format: .currency(code: viewModel.currencyCode))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.state.balance >= 0 ? .green : .red)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 12)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            viewModel.fetchData()
        }
        .onChange(of: isSheetPresented) { newValue in
            if !newValue {
                viewModel.fetchData()
            }
        }
    }
}





#Preview {
    //HomeView()
}
