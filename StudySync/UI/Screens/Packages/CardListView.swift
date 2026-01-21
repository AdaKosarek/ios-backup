//
//  CardListView.swift
//  StudySync
//

import SwiftUI

struct CardListView: View {
    @State var viewModel: CardListViewModel
    @State private var showingAddCard = false
    
    var body: some View {
        ZStack {
            // 1. VRSTVA: Animované pozadí
            BackgroundBlob()
                .ignoresSafeArea()
            
            // 2. VRSTVA: Obsah
            ScrollView {
                // Vyčleněný obsah
                listContent
                    .padding()
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle(viewModel.group.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddCard = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .accessibilityIdentifier("AddCardButton")
            }
        }
        .sheet(isPresented: $showingAddCard) {
            AddCardView(viewModel: viewModel)
        }
    }
    
    // MARK: - Subviews (Rozdělení pro kompilátor)
    
    @ViewBuilder
    private var listContent: some View {
        LazyVStack(spacing: 12) {
            if viewModel.group.cards.isEmpty {
                ContentUnavailableView(
                    "Žádné kartičky",
                    systemImage: "rectangle.portrait.on.rectangle.portrait.fill",
                    description: Text("Tato skupina je prázdná. Klikni na + a přidej otázku.")
                )
                .padding(.top, 50)
            } else {
                ForEach(viewModel.group.cards) { card in
                    cardRow(for: card)
                }
            }
        }
    }
    
    // Samostatná funkce pro řádek karty
    private func cardRow(for card: StudyCard) -> some View {
        // Zabalíme do Buttonu, aby fungoval .tiltStyle() (animace kliknutí)
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            StudyCardRowView(card: card)
        }
        //.simple3D() // Aplikace 3D efektu a stylu
        
        .contextMenu {
            Button(role: .destructive) {
                // Voláme přímo ViewModel
                viewModel.deleteCard(card)
            } label: {
                Label("Smazat kartu", systemImage: "trash")
            }
        }
        .accessibilityIdentifier("CardRow_\(card.question)")
    }
}
