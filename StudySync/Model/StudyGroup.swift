//
//  StudyGroup.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import Foundation
import SwiftData

@Model
class StudyGroup {
    var id: UUID
    var name: String
    var dateCreated: Date
    
    // Zpětná vazba: Skupina ví, do kterého balíčku patří
    var package: StudyPackage?
    
    // TOTO TI TAM CHYBĚLO: Seznam karet v této skupině
    @Relationship(deleteRule: .cascade) var cards: [StudyCard] = []
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.dateCreated = Date()
    }
}
