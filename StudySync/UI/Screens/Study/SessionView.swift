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
    
    // NOVÉ: Stav pro zobrazení potvrzovacího okna
    @State private var showExitAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                if isFinished {
                    // ... (tvůj kód pro výsledky - beze změny) ...
                    // Pro zkrácení zde vypisuji jen tu část, co už máš
                    VStack(spacing: 20) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.yellow)
                        Text("Session Complete!")
                        // ... zbytek výsledků ...
                        Button("Uložit a zpět") {
                            saveSession()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 50)
                } else {
                    // --- PROBÍHAJÍCÍ UČENÍ ---
                    
                    ProgressView(value: Double(currentIndex), total: Double(cards.count))
                        .padding()
                    
                    Text("\(currentIndex + 1) / \(cards.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    if !cards.isEmpty {
                        // Tvoje karta
                         RoundedRectangle(cornerRadius: 20)
                             .fill(Color.white)
                             .shadow(radius: 5)
                             .overlay(Text(isFlipped ? cards[currentIndex].answer : cards[currentIndex].question))
                             .frame(height: 450)
                             .padding()
                             .onTapGesture {
                                 isFlipped.toggle()
                             }
                    } else {
                        Text("Tento balíček je prázdný.")
                    }
                    
                    Spacer()
                    
                    // Tlačítka dole
                    HStack(spacing: 30) {
                        if isFlipped {
                            Button(action: { recordAnswer(isCorrect: false) }) {
                                VStack {
                                    Image(systemName: "xmark.circle.fill").font(.largeTitle)
                                    Text("Nevěděl")
                                }
                                .foregroundStyle(.red)
                            }
                            Button(action: { recordAnswer(isCorrect: true) }) {
                                VStack {
                                    Image(systemName: "checkmark.circle.fill").font(.largeTitle)
                                    Text("Věděl")
                                }
                                .foregroundStyle(.green)
                            }
                        } else {
                            Text("Klepni na kartu pro zobrazení odpovědi")
                                .foregroundStyle(.secondary).font(.caption)
                        }
                    }
                    .frame(height: 80)
                    .padding(.bottom, 30)
                }
            }
            
            if isFinished {
                ConfettiView().ignoresSafeArea()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(isFinished ? "Výsledek" : "Studium")
        // ZMĚNA: Skryjeme výchozí tlačítko zpět, abychom dali vlastní (volitelné)
        .navigationBarBackButtonHidden(true)
        
        // ZMĚNA: Přidání toolbaru s tlačítkem pro ukončení
        .toolbar {
            // Tlačítko vlevo nahoře (nebo vpravo, změň na .topBarTrailing)
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if isFinished {
                        // Pokud je hotovo, odejdi rovnou (a ulož)
                        saveSession()
                        dismiss()
                    } else {
                        // Pokud běží studium, zeptat se
                        showExitAlert = true
                    }
                }) {
                    // Můžeš použít text "Ukončit" nebo ikonku křížku/šipky
                    HStack {
                        Image(systemName: "chevron.left")
                        
                    }
                }
            }
        }
        // ZMĚNA: Alert okno pro potvrzení odchodu
        .alert("Ukončit studium?", isPresented: $showExitAlert) {
            Button("Zrušit", role: .cancel) { }
            Button("Ukončit", role: .destructive) {
                dismiss() // Tady odejdeme bez uložení
            }
        } message: {
            Text("Váš aktuální postup v této lekci nebude uložen.")
        }
    }
    
    // ... tvé funkce recordAnswer a saveSession zůstávají stejné ...
    private func recordAnswer(isCorrect: Bool) {
        if isCorrect { correctCount += 1 } else { incorrectCount += 1 }
        withAnimation { isFlipped = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if currentIndex < cards.count - 1 {
                withAnimation { currentIndex += 1 }
            } else {
                isFinished = true
            }
        }
    }
    
    private func saveSession() {
        // modelContext.insert(...)
    }
}
