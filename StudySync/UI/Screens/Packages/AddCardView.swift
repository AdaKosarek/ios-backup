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
                BackgroundBlob()
                    .ignoresSafeArea()
                    .opacity(0.3)
                
                Form {
                    Section("ques") {
                        TextField("eg_fran", text: $question, axis: .vertical)
                            .focused($isQuestionFocused)
                            .lineLimit(2...5)
                            .accessibilityIdentifier("questionField")
                    }
                    
                    Section(
                        header: Text("ans"),
                        footer: Group {
                            if !question.isEmpty {
                                Text("hid")
                            }
                        }
                    ) {
                        HStack(alignment: .top) {
                            TextField("hid2", text: $answer, axis: .vertical)
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
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("new_card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("action_cancle") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("save") {
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
                print("Gemini error: \(error)")
                await MainActor.run {
                    self.isGenerating = false
                }
            }
        }
    }
}
