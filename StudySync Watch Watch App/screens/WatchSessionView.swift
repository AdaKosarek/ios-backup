
//  WatchSessionView.swift
//  StudySync Watch Watch App
//
//  Created by Miroslav Musil on 18.12.2025.
//


import SwiftUI

struct WatchSessionView: View {
    let cards: [CardDTO] // Změna typu na DTO
    var connector: WatchConnector // Přidáme konektor pro odeslání výsledku
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var isAnswerShown = false
    @State private var correctCount = 0
    @State private var incorrectCount = 0
    
    var body: some View {
        // ... (UI kód zůstává stejný, jen používá cards[currentIndex].question atd.) ...
        
        // V části, kde je obrazovka "Complete!":
        Button("Done") {
            finishSession()
        }
    }
    
    private func finishSession() {
        // Vytvoříme výsledek
        let result = SessionResultDTO(
            correct: correctCount,
            incorrect: incorrectCount,
            date: Date()
        )
        
        // Pošleme zpět do iPhonu
        connector.sendResultToPhone(result: result)
        
        dismiss()
    }
}
