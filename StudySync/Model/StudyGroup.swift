//
//  StudyGroup.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import Foundation
import SwiftData

@Model
class StudyGroup: Identifiable {
    var id: UUID
    var name: String
    var dateCreated: Date
    var package: StudyPackage?
    
    @Relationship(deleteRule: .cascade) var cards: [StudyCard] = []
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.dateCreated = Date()
    }
}
