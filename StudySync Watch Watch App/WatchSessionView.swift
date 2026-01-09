//
//  WatchSessionView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

struct WatchSessionView: View {
    // Tady bychom normálně filtrovali karty, pro ukázku bereme všechny
    @Query private var cards: [StudyCard]
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentIndex = 0
    @State private var isAnswerShown = false
    
    var body: some View {
        VStack {
            if cards.isEmpty {
                Text("Žádné karty k dispozici.")
                    .font(.caption)
            } else if currentIndex < cards.count {
                // --- PROBÍHAJÍCÍ SESSION ---
                ScrollView {
                    VStack(spacing: 10) {
                        Text("Otázka \(currentIndex + 1)/\(cards.count)")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                        
                        // Text Otázky
                        Text(cards[currentIndex].question)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.vertical)
                        
                        if isAnswerShown {
                            // Text Odpovědi
                            Text(cards[currentIndex].answer)
                                .foregroundStyle(.blue)
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                            
                            // Tlačítka hodnocení
                            HStack {
                                Button(action: { nextCard() }) {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(.red)
                                }
                                .background(Color.red.opacity(0.2))
                                .clipShape(Circle())
                                
                                Button(action: { nextCard() }) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.green)
                                }
                                .background(Color.green.opacity(0.2))
                                .clipShape(Circle())
                            }
                        } else {
                            // Tlačítko Odhalit
                            Button("Ukázat odpověď") {
                                withAnimation {
                                    isAnswerShown = true
                                }
                            }
                        }
                    }
                }
            } else {
                // --- KONEC ---
                VStack {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title)
                        .foregroundStyle(.green)
                    Text("Hotovo!")
                    Button("Zavřít") {
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Session")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func nextCard() {
        // Posun na další kartu
        isAnswerShown = false
        currentIndex += 1
    }
}

#Preview {
    WatchSessionView()
}
