//
//  DataService.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import SwiftData


class SwiftDataService: DataServiceProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchPackages() throws -> [StudyPackage] {
        let descriptor = FetchDescriptor<StudyPackage>(sortBy: [SortDescriptor(\.dateCreated, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }
    
    func addPackage(_ package: StudyPackage) {
        modelContext.insert(package)
        try? modelContext.save()
    }
    
    func deletePackage(_ package: StudyPackage) {
        modelContext.delete(package)
        try? modelContext.save()
    }
    

    func addGroup(to package: StudyPackage, name: String) {
        let group = StudyGroup(name: name)
        package.groups.append(group)
        try? modelContext.save()
    }
    
    func deleteGroup(_ group: StudyGroup) {
        modelContext.delete(group)
        try? modelContext.save()
    }
    
    //cards
    func addCard(to group: StudyGroup, question: String, answer: String) {
        let card = StudyCard(question: question, answer: answer)
        group.cards.append(card)
        try? modelContext.save()
    }
    
    func deleteCard(_ card: StudyCard) {
        modelContext.delete(card)
        try? modelContext.save()
    }
    
    //sess
    func saveSession(_ session: StudySession) {
        modelContext.insert(session)
        try? modelContext.save()
    }
    
    func fetchSessions() throws -> [StudySession] {
        let descriptor = FetchDescriptor<StudySession>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }
}


