import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    
    // View Model passed from parent
    var viewModel: CardListViewModel
    
    @State private var question = ""
    @State private var answer = ""
    @FocusState private var isQuestionFocused: Bool
    
    // --- NEW FOR GEMINI ---
    @State private var isGenerating = false // For loading spinner
    private let geminiService = GeminiService() // Service instance
    // -----------------------
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Otázka") {
                    TextField("Např. Hlavní město Francie?", text: $question, axis: .vertical)
                        .focused($isQuestionFocused)
                        .lineLimit(2...5)
                        .accessibilityIdentifier("questionField")
                }
                
                // CORRECTED SECTION WITH FOOTER
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
                        
                        // --- GEMINI BUTTON ---
                        Button(action: {
                            generateAIAnswer()
                        }) {
                            if isGenerating {
                                ProgressView()
                                    .controlSize(.small)
                            } else {
                                Image(systemName: "sparkles") // AI Icon
                                    .foregroundStyle(.purple)
                                    .font(.title2)
                            }
                        }
                        .buttonStyle(.plain) // Prevent clicking the whole row
                        .disabled(question.isEmpty || isGenerating) // Cannot click without question
                        .padding(.leading, 5)
                    }
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
                    .accessibilityIdentifier("saveButton")
                }
            }
        }
        .onAppear {
            isQuestionFocused = true
        }
    }
    
    // --- FUNCTION TO CALL GEMINI ---
    private func generateAIAnswer() {
        // Hide keyboard
        isQuestionFocused = false
        isGenerating = true
        
        Task {
            do {
                // Call our service
                let result = try await geminiService.generateAnswer(for: question)
                
                // Update UI on main thread
                await MainActor.run {
                    self.answer = result
                    self.isGenerating = false
                }
            } catch {
                print("Chyba Gemini: \(error)")
                await MainActor.run {
                    self.isGenerating = false
                    // Here you could show an alert with the error
                }
            }
        }
    }
}
