//
//  AddCardView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Potřebujeme vědět, do které skupiny kartu přidáváme
    var group: StudyGroup
    
    @State private var question = ""
    @State private var answer = ""
    @FocusState private var isQuestionFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Otázka") {
                    TextField("Např. a² + b² = ?", text: $question, axis: .vertical)
                        .focused($isQuestionFocused)
                        .lineLimit(2...5)
                        .accessibilityIdentifier("questionField") // PŘIDÁNO PRO TESTY
                }
                
                Section("Odpověď") {
                    TextField("Např. c²", text: $answer, axis: .vertical)
                        .lineLimit(2...5)
                        .accessibilityIdentifier("answerField") // PŘIDÁNO PRO TESTY
                }
            }
            .navigationTitle("Nová karta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložit") {
                        saveCard()
                    }
                    .disabled(question.isEmpty || answer.isEmpty)
                    .accessibilityIdentifier("createPackageButton") // PŘIDÁNO PRO TESTY
                }
            }
        }
        .onAppear {
            isQuestionFocused = true
        }
    }
    
    private func saveCard() {
        let newCard = StudyCard(question: question, answer: answer)
        group.cards.append(newCard)
        dismiss()
    }
}
