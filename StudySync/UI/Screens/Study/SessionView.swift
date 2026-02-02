//
//  SessionView.swift
//  StudySync
//
//  Created by mp on 18.12.2025.
//

import SwiftUI

struct SessionView: View {
    @State var viewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showExitAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isFinished {
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
                    VStack {
                        ProgressView(value: viewModel.progress)
                            .padding()
                        
                        Text("\(viewModel.currentIndex + 1) / \(viewModel.cards.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
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
            
            if viewModel.isFinished {
                ConfettiView()
                    .ignoresSafeArea()
            }
        }
    }
}
