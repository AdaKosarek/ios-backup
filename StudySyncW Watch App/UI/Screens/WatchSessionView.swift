//
//  WatchSessionView.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI

struct WatchSessionView: View {
    var cards: [CardDTO] = []
    
    @State private var currentIndex = 0
    @State private var isAnswerRevealed = false
    
    @State private var correctCount = 0
    @State private var incorrectCount = 0
    
    @Environment(\.dismiss) var dismiss
    @State private var sessionCards: [CardDTO] = []
    
    var currentCard: CardDTO? {
        if sessionCards.indices.contains(currentIndex) {
            return sessionCards[currentIndex]
        }
        return nil
    }
    
    var body: some View {
        VStack(spacing: 2) {
            
            if let card = currentCard {
                ProgressView(
                    value: Double(currentIndex + 1),
                    total: Double(sessionCards.count)
                )
                    .tint(.blue)
                    .scaleEffect(y: 0.3)
                    .padding(.horizontal)
                    .padding(.top, 4)
                
                Text(isAnswerRevealed ? "Odpověď" : "Otázka")
                    .font(.caption2)
                    .foregroundStyle(isAnswerRevealed ? .orange : .gray)
                    .padding(.top, 2)
                
                ScrollView {
                    Text(textToShow(for: card))
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: .infinity)
                
                if !isAnswerRevealed {
                    Button(action: {
                        isAnswerRevealed = true
                    }) {
                        Text("Ukázat odpověď")
                            .font(.footnote)
                            .fontWeight(.bold)
                    }
                    .tint(.blue)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .clipShape(Capsule())
                    .padding(.bottom, 2)
                    
                } else {
                    HStack(spacing: 12) {
                        Button(action: {
                            incorrectCount += 1
                            nextCard()
                        }) {
                            Image(systemName: "xmark")
                                .font(.headline)
                        }
                        .tint(.red)
                        .buttonStyle(.borderedProminent)
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                        
                        Button(action: {
                            correctCount += 1
                            nextCard()
                        }) {
                            Image(systemName: "checkmark")
                                .font(.headline)
                        }
                        .tint(.green)
                        .buttonStyle(.borderedProminent)
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                    }
                    .padding(.bottom, 4)
                }
                
                Text("\(currentIndex + 1) / \(sessionCards.count)")
                    .font(.system(size: 9))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 2)
                
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .font(.title)
                        .foregroundStyle(.yellow)
                    
                    Text("Hotovo!")
                        .font(.headline)
                    
                    Button("Zavřít") {
                        dismiss()
                    }
                    .font(.footnote)
                    .controlSize(.small)
                    .tint(.gray)
                }
            }
        }
        .onAppear {
            if sessionCards.isEmpty {
                sessionCards = Array(cards.shuffled().prefix(20))
            }
        }
    }
    
    private func textToShow(for card: CardDTO) -> String {
        let text = isAnswerRevealed ? card.answer : card.question
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "⚠️ Prázdná karta"
        }
        return text
    }
    
    private func nextCard() {
        isAnswerRevealed = false
        currentIndex += 1

        if currentIndex >= sessionCards.count {
            finishSession()
        }
    }

    private func finishSession() {
        let result = SessionResultDTO(
            correct: correctCount,
            incorrect: incorrectCount,
            date: Date()
        )

        WatchConnector.shared.sendSessionResult(result)
    }
}
