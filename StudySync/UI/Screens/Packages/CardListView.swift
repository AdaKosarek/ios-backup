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
    @State private var showingAddCard = false // 1. Stav pro otevření okna
    
    var body: some View {
        List {
            if group.cards.isEmpty {
                ContentUnavailableView(
                    "Žádné kartičky",
                    systemImage: "rectangle.portrait.on.rectangle.portrait.fill",
                    description: Text("Tato skupina je prázdná. Klikni na + a přidej otázku.")
                )
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
                }
                .onDelete(perform: deleteCards) // Přidáme i mazání
            }
        }
        .navigationTitle(group.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // 2. Tlačítko, které změní stav na true
                Button(action: { showingAddCard = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        // 3. Zobrazení formuláře
        .sheet(isPresented: $showingAddCard) {
            AddCardView(group: group)
        }
    }
    
    // Funkce pro mazání karet
    private func deleteCards(offsets: IndexSet) {
        withAnimation {
            // Protože mažeme z pole relationshipu, musíme to udělat trochu jinak
            // než jen modelContext.delete(). Musíme je vyhodit ze skupiny.
            // Ale nejjednodušší ve SwiftData pro Cascade delete je:
            
            // Získání IDček karet, které chceme smazat
            let cardsToDelete = offsets.map { group.cards[$0] }
            
            // Odstranění z pole (SwiftData to pochopí a smaže je z DB,
            // pokud máme nastaveno deleteRule: .cascade, jinak jen zruší vazbu.
            // Pro jistotu mažeme přímo z kontextu:
            for card in cardsToDelete {
                // Karta musí vědět o svém kontextu, pokud ne, fallback na odstranění z pole
                if let context = card.modelContext {
                    context.delete(card)
                } else {
                    // Fallback
                    group.cards.removeAll(where: { $0.id == card.id })
                }
            }
        }
    }
}
