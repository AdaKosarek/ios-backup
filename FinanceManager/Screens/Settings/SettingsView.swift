//
//  SettingsView.swift
//  FinanceManager
//
//  Created by mp on 23.06.2025.
//

import SwiftUI
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Currency")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Picker("Currency", selection: $viewModel.currencyCode) {
                            ForEach(["CZK", "EUR", "USD"], id: \.self) { currency in
                                Text(currency)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    )

                    Spacer()
                }
                .padding(.top, 12)
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.updateCurrency(viewModel.currencyCode)
                        dismiss()
                    }
                }
            }
        }
    }
}





#Preview {
    SettingsView()
}
