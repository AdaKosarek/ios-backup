//
//  WatchContentView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

struct WatchContentView: View {
    @Environment(\.modelContext) private var modelContext
    // Načteme balíčky, abychom zjistili, zda je databáze prázdná
    @Query private var packages: [StudyPackage]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    
                    if packages.isEmpty {
                        // --- STAV 1: PRÁZDNÁ DATABÁZE ---
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundStyle(.yellow)
                            
                            Text("Žádná data")
                                .font(.headline)
                            
                            Text("V simulátoru se data z iPhone nesynchronizují automaticky.")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                            
                            // Tlačítko pro generování dat
                            Button("Nahrát testovací data") {
                                addMockData()
                            }
                            .tint(.green)
                        }
                        .padding()
                        
                    } else {
                        // --- STAV 2: MÁME DATA (Normální aplikace) ---
                        
                        // 1. Statistiky (Kroužek)
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                            Circle()
                                .trim(from: 0, to: 0.4) // Pevně nastaveno pro demo
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            
                            VStack {
                                Text("12")
                                    .font(.title2)
                                    .bold()
                                Text("left")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(height: 100)
                        .padding(.top)
                        
                        Text("Streak: 12 🔥")
                            .font(.caption)
                            .foregroundStyle(.orange)
                        
                        // 2. Tlačítko Start Session
                        NavigationLink(destination: WatchSessionView()) {
                            Text("Start Session")
                                .foregroundStyle(.black) // Černý text na modrém pozadí (čitelnost)
                                .bold()
                        }
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .padding(.top)
                        
                        // Tlačítko pro smazání (aby šlo testovat znovu)
                        Button("Resetovat data") {
                            resetData()
                        }
                        .foregroundStyle(.red)
                        .font(.caption2)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("StudySync")
        }
    }
    
    // Funkce pro vytvoření falešných dat přímo v hodinkách
    private func addMockData() {
        let package = StudyPackage(name: "Demo Balíček", colorHex: "blue", icon: "star.fill")
        let group = StudyGroup(name: "Všeobecné")
        
        let c1 = StudyCard(question: "Kolik je 2+2?", answer: "4")
        let c2 = StudyCard(question: "Hlavní město Francie?", answer: "Paříž")
        let c3 = StudyCard(question: "Je Swift super?", answer: "Ano!")
        
        // Propojení
        group.cards = [c1, c2, c3]
        package.groups.append(group)
        
        // Uložení
        modelContext.insert(package)
    }
    
    // Funkce pro vymazání dat
    private func resetData() {
        do {
            try modelContext.delete(model: StudyPackage.self)
        } catch {
            print("Chyba při mazání: \(error)")
        }
    }
}

#Preview {
    WatchContentView()
        .modelContainer(for: StudyPackage.self, inMemory: true)
}
