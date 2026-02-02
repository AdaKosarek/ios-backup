//
//  MockDataSevice.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import SwiftData
@testable import StudySync

class MockDataService: DataServiceProtocol {
    
    var packages: [StudyPackage] = []
    var sessions: [StudySession] = []
    
    func fetchPackages() throws -> [StudyPackage] {
        return packages
    }
    
    func addPackage(_ package: StudyPackage) {
        packages.append(package)
    }
    
    func deletePackage(_ package: StudyPackage) {
        packages.removeAll { $0.id == package.id }
    }
    
    func addGroup(to package: StudyPackage, name: String) {
        let group = StudyGroup(name: name)
        package.groups.append(group)
    }
    
    func deleteGroup(_ group: StudyGroup) {
        for package in packages {
            if let index = package.groups.firstIndex(where: { $0.id == group.id }) {
                package.groups.remove(at: index)
            }
        }
    }
    
    func addCard(to group: StudyGroup, question: String, answer: String) {
        let card = StudyCard(question: question, answer: answer)
        group.cards.append(card)
    }
    
    func deleteCard(_ card: StudyCard) {
        for package in packages {
            for group in package.groups {
                if let index = group.cards.firstIndex(where: { $0.id == card.id }) {
                    group.cards.remove(at: index)
                }
            }
        }
    }
    
    // 4. Sessions (Musí mít 'throws'!)
    func saveSession(_ session: StudySession) {
        sessions.append(session)
    }
    
    func fetchSessions() throws -> [StudySession] {
        return sessions
    }
    func addMockDataForUITests() {
            // 1. Balíček
            let math = StudyPackage(name: "Matematika", colorHex: "blue", icon: "function")
            packages.append(math)
            
            // 2. Skupina
            let group = StudyGroup(name: "Testovací Skupina")
            math.groups.append(group)
            
            // 3. Karta (pro testy mazání)
            let card = StudyCard(question: "Fixní Otázka", answer: "Fixní Odpověď")
            group.cards.append(card)
            
            // 4. Session (pro statistiky)
            let session = StudySession(correctCount: 8, incorrectCount: 2)
            sessions.append(session)
        }
}
