//
//  DataServiceProtocol.swift
//  StudySync
//
//  Created by mp on 20.01.2026.
//

import Foundation
import SwiftData

// 1. Protokol definující kontrakt (rozhraní)
protocol DataServiceProtocol {
    func fetchPackages() throws -> [StudyPackage]
    func addPackage(_ package: StudyPackage)
    func deletePackage(_ package: StudyPackage)
    
    func addGroup(to package: StudyPackage, name: String)
    func deleteGroup(_ group: StudyGroup)
    
    func addCard(to group: StudyGroup, question: String, answer: String)
    func deleteCard(_ card: StudyCard)
    
    func saveSession(_ session: StudySession)
    func fetchSessions() throws -> [StudySession]
}
