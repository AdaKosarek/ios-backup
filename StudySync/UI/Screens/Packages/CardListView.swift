//
//  CardListView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

struct CardListView: View {
    @Bindable var group: StudyGroup
    @State private var showingAddCard = false
    
    var body: some View {
        List {
            if group.cards.isEmpty {
                ContentUnavailableView(
                    "Žádné kartičky",
                    systemImage: "rectangle.portrait.on.rectangle.portrait.fill",
                    description: Text("Tato skupina je prázdná. Klikni na + a přidej otázku.")
                )
                .accessibilityIdentifier("EmptyStateView") // 1. ID pro prázdný stav
            } else {
                ForEach(group.cards) { card in
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
                    // Volitelné: ID pro konkrétní řádek, pokud bychom chtěli být precizní
                    .accessibilityIdentifier("CardRow_\(card.question)")
                }
                .onDelete(perform: deleteCards)
            }
        }
        .navigationTitle(group.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddCard = true }) {
                    Image(systemName: "plus")
                }
                .accessibilityIdentifier("AddCardButton") // 2. ID pro tlačítko plus
            }
        }
        .sheet(isPresented: $showingAddCard) {
            AddCardView(group: group)
        }
    }
    
    private func deleteCards(offsets: IndexSet) {
        withAnimation {
            let cardsToDelete = offsets.map { group.cards[$0] }
            for card in cardsToDelete {
                if let context = card.modelContext {
                    context.delete(card)
                } else {
                    group.cards.removeAll(where: { $0.id == card.id })
                }
            }
        }
    }
}
