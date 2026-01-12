//
//  Mock.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

import SwiftUI
import SwiftData

struct UITestHelper: ViewModifier {
    @Environment(\.modelContext) private var modelContext
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if CommandLine.arguments.contains("--mock-data") {
                    setupMockData()
                }
            }
    }
    
    @MainActor
    private func setupMockData() {
        // 1. Vyčistit stará data
        try? modelContext.delete(model: StudyPackage.self)
        try? modelContext.delete(model: StudySession.self)
        
        // 2. Vytvořit Balíček
        let math = StudyPackage(name: "Matematika", colorHex: "blue", icon: "function")
        modelContext.insert(math)
        
        // 3. Vytvořit Skupinu
        let group = StudyGroup(name: "Testovací Skupina")
        math.groups.append(group) // Připojíme k balíčku
        
        // 4. Vytvořit Kartu (TUTO BUDEME MAZAT)
        let card = StudyCard(question: "Fixní Otázka", answer: "Fixní Odpověď")
        group.cards.append(card) // Připojíme ke skupině
        
        // 5. Session (volitelné, pro widgety)
        let session = StudySession(correctCount: 8, incorrectCount: 2)
        modelContext.insert(session)
        
        try? modelContext.save()
    }
}

extension View {
    func handleUITests() -> some View {
        self.modifier(UITestHelper())
    }
}
