//
//  AddCardView.swift
//  StudySync
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    
    // View Model předaný z rodiče
    var viewModel: CardListViewModel
    
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
                        // --- KLÍČOVÉ PRO TESTY ---
                        .accessibilityIdentifier("questionField")
                }
                
                Section("Odpověď") {
                    TextField("Např. c²", text: $answer, axis: .vertical)
                        .lineLimit(2...5)
                        // --- KLÍČOVÉ PRO TESTY ---
                        .accessibilityIdentifier("answerField")
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
                        viewModel.addCard(question: question, answer: answer)
                        dismiss()
                    }
                    .disabled(question.isEmpty || answer.isEmpty)
                    // --- KLÍČOVÉ PRO TESTY ---
                    .accessibilityIdentifier("saveButton")
                }
            }
        }
        .onAppear {
            isQuestionFocused = true
        }
    }
}
