//
//  SessionView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

//
//  SessionView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

struct SessionView: View {
    @State var viewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    // Stav pro alert při pokusu o ukončení
    @State private var showExitAlert = false
    
    var body: some View {
        // 1. ZMĚNA: Použijeme ZStack jako hlavní kontejner, abychom mohli vrstvit konfety přes obsah
        ZStack {
            
            // --- HLAVNÍ OBSAH (VStack) ---
            VStack {
                if viewModel.isFinished {
                    // --- VÝSLEDKOVÁ OBRAZOVKA ---
                    VStack(spacing: 20) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.yellow)
                        
                        Text("Hotovo!")
                            .font(.largeTitle)
                            .bold()
                        
                        HStack(spacing: 40) {
                            VStack {
                                Text("\(viewModel.correctCount)")
                                    .font(.title)
                                    .foregroundStyle(.green)
                                    .bold()
                                Text("Správně")
                            }
                            VStack {
                                Text("\(viewModel.incorrectCount)")
                                    .font(.title)
                                    .foregroundStyle(.red)
                                    .bold()
                                Text("Špatně")
                            }
                        }
                        .padding()
                        
                        Button("Ukončit") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                } else if let card = viewModel.currentCard {
                    // --- PROBÍHAJÍCÍ STUDIUM ---
                    VStack {
                        // Progress bar
                        ProgressView(value: viewModel.progress)
                            .padding()
                        
                        Text("\(viewModel.currentIndex + 1) / \(viewModel.cards.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        // Animovaná karta (FlipCardView)
                        FlipCardView(
                            question: card.question,
                            answer: card.answer,
                            isFlipped: viewModel.isFlipped,
                            onTap: {
                                withAnimation {
                                    viewModel.flipCard()
                                }
                            }
                        )
                        
                        Spacer()
                        
                        // Tlačítka Hodnocení
                        HStack(spacing: 40) {
                            Button(action: { withAnimation { viewModel.markIncorrect() } }) {
                                VStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 60))
                                    Text("Nevěděl")
                                }
                                .foregroundStyle(.red)
                            }
                            
                            Button(action: { withAnimation { viewModel.markCorrect() } }) {
                                VStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 60))
                                    Text("Věděl")
                                }
                                .foregroundStyle(.green)
                            }
                        }
                        .padding(.bottom, 30)
                        .opacity(viewModel.isFlipped ? 1 : 0)
                    }
                } else {
                    Text("Žádné karty k zobrazení")
                }
            }
            .navigationTitle("Studium")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        if viewModel.isFinished {
                            dismiss()
                        } else {
                            showExitAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Zpět")
                        }
                    }
                }
            }
            .alert("Ukončit studium?", isPresented: $showExitAlert) {
                Button("Zrušit", role: .cancel) { }
                Button("Ukončit", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Váš aktuální postup v této lekci nebude uložen.")
            }
            
            // 2. ZMĚNA: Přidání konfet "nad" obsah
            // Zobrazí se pouze, pokud je lekce dokončena
            if viewModel.isFinished {
                ConfettiView()
                    .ignoresSafeArea() // Aby padaly přes celou obrazovku
            }
        }
    }
}
