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
            BackgroundBlob()
                .ignoresSafeArea()
            
            ScrollView {
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
    
    private func cardRow(for card: StudyCard) -> some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            StudyCardRowView(card: card)
        }
        
        .contextMenu {
            Button(role: .destructive) {
                viewModel.deleteCard(card)
            } label: {
                Label("Smazat kartu", systemImage: "trash")
            }
        }
        .accessibilityIdentifier("CardRow_\(card.question)")
    }
}
