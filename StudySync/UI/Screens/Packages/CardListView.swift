//
//  CardListView.swift
//  StudySync
//

import SwiftUI

struct CardListView: View {
    @State var viewModel: CardListViewModel
    @State private var showingAddCard = false
    
    var body: some View {
        List {
            if viewModel.group.cards.isEmpty {
                ContentUnavailableView(
                    "Žádné kartičky",
                    systemImage: "rectangle.portrait.on.rectangle.portrait.fill",
                    description: Text("Tato skupina je prázdná. Klikni na + a přidej otázku.")
                )
            } else {
                ForEach(viewModel.group.cards) { card in
                    VStack(alignment: .leading) {
                        Text(card.question)
                            .font(.headline)
                            .lineLimit(2)
                        Text(card.answer)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .padding(.vertical, 4)
                    // Volitelné: ID pro řádek karty (pro testy mazání)
                    .accessibilityIdentifier("CardRow_\(card.question)")
                }
                .onDelete(perform: viewModel.deleteCard)
            }
        }
        .navigationTitle(viewModel.group.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddCard = true }) {
                    Image(systemName: "plus")
                }
                // --- KLÍČOVÉ PRO TESTY ---
                .accessibilityIdentifier("AddCardButton")
            }
        }
        .sheet(isPresented: $showingAddCard) {
            AddCardView(viewModel: viewModel)
        }
    }
}
