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
            packages = try dataService.fetchPackages()
            syncToWatch()
        } catch {
            print("Chyba při načítání balíčků: \(error)")
        }
    }
    
    // --- FUNKCE PRO SYNCHRONIZACI ---
    func syncToWatch() {
        print("⚡️ Začínám synchronizaci do hodinek...")
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
                            CardDTO(id: card.id, question: card.question, answer: card.answer)
                        }
                    )
                }
            )
        }
        WatchConnector.shared.sendDataToWatch(packages: packageDTOs)
    }
    
    // --- PŘIDÁNÍ BALÍČKU ---
    func addPackage(name: String, color: String, icon: String) {
        let newPackage = StudyPackage(name: name, colorHex: color, icon: icon)
        dataService.addPackage(newPackage)
        loadPackages()
    }
    
    // --- SMAZÁNÍ BALÍČKU (Přes IndexSet - pro swipe gesta) ---
    func deletePackage(at offsets: IndexSet) {
        for index in offsets {
            let package = packages[index]
            dataService.deletePackage(package)
        }
        loadPackages()
    }
    
    // --- NOVÁ FUNKCE: SMAZÁNÍ KONKRÉTNÍHO BALÍČKU (Pro kontextové menu) ---
    func deletePackage(_ package: StudyPackage) {
        dataService.deletePackage(package)
        loadPackages()
    }
    
    // --- MOCK DATA ---
    func addMockData() {
        let mockPackage = StudyPackage(name: "Demo Balíček", colorHex: "blue", icon: "star.fill")
        let group = StudyGroup(name: "Základní")
        group.cards.append(StudyCard(question: "Otázka 1", answer: "Odpověď 1"))
        mockPackage.groups.append(group)
        
        dataService.addPackage(mockPackage)
        loadPackages()
    }
}
