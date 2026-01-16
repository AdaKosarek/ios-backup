//
//  PackagesListViewModel.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import SwiftData
import Observation

@Observable
class PackagesListViewModel {
    var packages: [StudyPackage] = []
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    // --- HLAVNÍ FUNKCE PRO NAČTENÍ DAT ---
    func loadPackages() {
        do {
            // 1. Načteme data z databáze iPhonu
            packages = try dataService.fetchPackages()
            
            // 2. OKAMŽITĚ je pošleme do hodinek
            syncToWatch()
            
        } catch {
            print("Chyba při načítání balíčků: \(error)")
        }
    }
    
    // --- FUNKCE PRO SYNCHRONIZACI ---
    func syncToWatch() {
        print("⚡️ Začínám synchronizaci do hodinek...")
        
        // Musíme převést složité databázové objekty na jednoduché DTO zprávy
        let packageDTOs = packages.map { package in
            PackageDTO(
                id: package.id,
                name: package.name,
                colorHex: package.colorHex,
                groups: package.groups.map { group in
                    GroupDTO(
                        id: group.id,
                        name: group.name,
                        cards: group.cards.map { card in
                            CardDTO(
                                id: card.id,
                                question: card.question,
                                answer: card.answer
                            )
                        }
                    )
                }
            )
        }
        
        // Odešleme přes náš konektor
        WatchConnector.shared.sendDataToWatch(packages: packageDTOs)
    }
    
    // --- PŘIDÁNÍ BALÍČKU ---
    func addPackage(name: String, color: String, icon: String) {
        let newPackage = StudyPackage(name: name, colorHex: color, icon: icon)
        dataService.addPackage(newPackage)
        loadPackages() // Znovu načte a synchronizuje
    }
    
    // --- SMAZÁNÍ BALÍČKU ---
    func deletePackage(at offsets: IndexSet) {
        for index in offsets {
            let package = packages[index]
            dataService.deletePackage(package)
        }
        loadPackages() // Znovu načte a synchronizuje
    }
    
    // --- MOCK DATA (pro testování) ---
    func addMockData() {
        let mockPackage = StudyPackage(name: "Demo Balíček", colorHex: "blue", icon: "star.fill")
        let group = StudyGroup(name: "Základní")
        let card1 = StudyCard(question: "Otázka 1", answer: "Odpověď 1")
        let card2 = StudyCard(question: "Otázka 2", answer: "Odpověď 2")
        
        group.cards.append(card1)
        group.cards.append(card2)
        mockPackage.groups.append(group)
        
        dataService.addPackage(mockPackage)
        loadPackages() // Znovu načte a synchronizuje
    }
}
