//
//  AddCardView.swift
//  StudySync
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    var viewModel: CardListViewModel
    
    @State private var question = ""
    @State private var answer = ""
    @FocusState private var isQuestionFocused: Bool
    
    @State private var isGenerating = false
    private let geminiService = GeminiService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // ZMĚNA: Vlastní pozadí pro Sheet
                BackgroundBlob()
                    .ignoresSafeArea()
                    .opacity(0.3)
                
                Form {
                    Section("Otázka") {
                        TextField("Např. Hlavní město Francie?", text: $question, axis: .vertical)
                            .focused($isQuestionFocused)
                            .lineLimit(2...5)
                            .accessibilityIdentifier("questionField")
                    }
                    
                    Section(
                        header: Text("Odpověď"),
                        footer: Group {
                            if !question.isEmpty {
                                Text("Klikni na ✨ pro vygenerování odpovědi pomocí AI.")
                            }
                        }
                    ) {
                        HStack(alignment: .top) {
                            TextField("Zde bude odpověď...", text: $answer, axis: .vertical)
                                .lineLimit(2...8)
                                .accessibilityIdentifier("answerField")
                            
                            Button(action: { generateAIAnswer() }) {
                                if isGenerating {
                                    ProgressView().controlSize(.small)
                                } else {
                                    Image(systemName: "sparkles")
                                        .foregroundStyle(.purple)
                                        .font(.title2)
                                }
                            }
                            .buttonStyle(.plain)
                            .disabled(question.isEmpty || isGenerating)
                            .padding(.leading, 5)
                        }
                    }
                }
                .scrollContentBackground(.hidden) // ZMĚNA: Průhledný formulář
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
                    .accessibilityIdentifier("saveButton")
                }
            }
        }
        .onAppear {
            isQuestionFocused = true
        }
    }
    
    private func generateAIAnswer() {
        isQuestionFocused = false
        isGenerating = true
        
        Task {
            do {
                let result = try await geminiService.generateAnswer(for: question)
                await MainActor.run {
                    self.answer = result
                    self.isGenerating = false
                }
            } catch {
                print("Chyba Gemini: \(error)")
                await MainActor.run {
                    self.isGenerating = false
                }
            }
        }
    }
}
