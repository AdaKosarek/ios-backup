//
//  SessionView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

struct SessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Data pro sezení
    let cards: [StudyCard]
    
    // Stavy
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var correctCount = 0
    @State private var incorrectCount = 0
    @State private var isFinished = false
    
    // NOVÉ: Stav pro zobrazení potvrzovacího okna při odchodu
    @State private var showExitAlert = false
    
    var body: some View {
        VStack {
            if isFinished {
                // --- OBRAZOVKA VÝSLEDKŮ ---
                VStack(spacing: 20) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.yellow)
                    
                    Text("Session Complete!")
                        .font(.largeTitle)
                        .bold()
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("\(correctCount)")
                                .font(.title)
                                .foregroundStyle(.green)
                                .bold()
                            Text("Správně")
                        }
                        VStack {
                            Text("\(incorrectCount)")
                                .font(.title)
                                .foregroundStyle(.red)
                                .bold()
                            Text("Špatně")
                        }
                    }
                    .padding()
                    
                    Button("Uložit a zpět") {
                        saveSession()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("FinishButton")
                }
            } else {
                // --- PROBÍHAJÍCÍ UČENÍ ---
                
                // 1. Progress Bar nahoře
                ProgressView(value: Double(currentIndex), total: Double(cards.count))
                    .padding()
                
                Text("\(currentIndex + 1) / \(cards.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // 2. Karta (Pokud máme data)
                if !cards.isEmpty {
                    FlashCardView(
                        question: cards[currentIndex].question,
                        answer: cards[currentIndex].answer,
                        isFlipped: isFlipped
                    )
                    .frame(height: 450)
                    .padding()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isFlipped.toggle()
                        }
                    }
                    .accessibilityIdentifier("StudyCard")
                } else {
                    Text("Tento balíček je prázdný.")
                }
                
                Spacer()
                
                // 3. Tlačítka (Zobrazí se až po otočení)
                HStack(spacing: 30) {
                    if isFlipped {
                        Button(action: { recordAnswer(isCorrect: false) }) {
                            VStack {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.largeTitle)
                                Text("Nevěděl")
                            }
                            .foregroundStyle(.red)
                        }
                        .accessibilityIdentifier("ButtonWrong")
                        
                        Button(action: { recordAnswer(isCorrect: true) }) {
                            VStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.largeTitle)
                                Text("Věděl")
                            }
                            .foregroundStyle(.green)
                        }
                        .accessibilityIdentifier("ButtonCorrect")
                        
                    } else {
                        Text("Klepni na kartu pro zobrazení odpovědi")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                .frame(height: 80)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(isFinished ? "Výsledek" : "Studium")
        
        // --- NOVÉ: IMPLEMENTACE TLAČÍTKA ZPĚT ---
        .navigationBarBackButtonHidden(true) // Skryjeme výchozí systémové tlačítko
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if isFinished {
                        // Pokud je hotovo, rovnou odejdi a ulož
                        saveSession()
                        dismiss()
                    } else {
                        // Pokud běží lekce, zeptej se
                        showExitAlert = true
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        
                    }
                }
                .accessibilityIdentifier("BackButton") // ID pro testy
            }
        }
        // Alert pro potvrzení odchodu
        .alert("Ukončit studium?", isPresented: $showExitAlert) {
            Button("Zrušit", role: .cancel) { }
            Button("Ukončit", role: .destructive) {
                dismiss() // Odejít bez uložení
            }
        } message: {
            Text("Váš aktuální postup v této lekci nebude uložen.")
        }
    }
    
    // Logika posunu na další kartu
    private func recordAnswer(isCorrect: Bool) {
        if isCorrect {
            correctCount += 1
        } else {
            incorrectCount += 1
        }
        
        withAnimation {
            isFlipped = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if currentIndex < cards.count - 1 {
                withAnimation {
                    currentIndex += 1
                }
            } else {
                isFinished = true
            }
        }
    }
    
    private func saveSession() {
        let session = StudySession(correctCount: correctCount, incorrectCount: incorrectCount)
        modelContext.insert(session)
    }
}

