//
//  StatisticsView.swift
//  FinanceManager
//
//  Created by mp on 19.06.2025.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @Binding var isSheetPresented: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                Picker("", selection: $viewModel.state.isExpenseSelected) {
                    Text("Expenses").tag(true)
                    Text("Income").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                PeriodSelector(
                    periods: viewModel.state.availablePeriods,
                    selectedPeriod: viewModel.state.selectedPeriod ?? viewModel.state.availablePeriods.first!,
                    onSelect: viewModel.select,
                    title: { $0.title }
                )


                Divider().padding(.horizontal, 16)

                if !viewModel.state.chartData.isEmpty {
                    Chart(viewModel.state.chartData) { slice in
                        SectorMark(
                            angle: .value("Amount", slice.amount),
                            innerRadius: .ratio(0.5),
                            angularInset: 1
                        )
                        .foregroundStyle(slice.color)
                        .annotation(position: .overlay) {
                            Text(slice.percentageString)
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 300)
                    .padding(.horizontal)
                } else {
                    Text(viewModel.state.isExpenseSelected ? "No expenses to display" : "No income to display")
                        .foregroundColor(.secondary)
                        .frame(height: 300)
                }

                HStack {
                    Label(viewModel.state.isExpenseSelected ? "All Expenses" : "All Income", systemImage: "sum")
                        .foregroundColor(.primary)
                    Spacer()
                    Text(viewModel.state.totalAmount, format: .currency(code: viewModel.currencyCode))
                        .font(.headline)
                }
                .padding(.horizontal)

                VStack(spacing: 12) {
                    ForEach(viewModel.state.chartData) { slice in
                        HStack {
                            Label(slice.categoryName, systemImage: slice.icon)
                                .foregroundColor(slice.color)
                            Spacer()
                            Text(slice.amount, format: .currency(code: viewModel.currencyCode))
                                .foregroundColor(.primary)
                        }

                        ProgressView(value: slice.percentage)
                            .tint(.purple)
                    }
                }
                .padding(.horizontal)

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
        .onChange(of: viewModel.state.isExpenseSelected) { _ in
            viewModel.fetchData()
        }
    }
}




#Preview {
    //StatisticsView()
}
