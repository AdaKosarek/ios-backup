//
//  StudyPackage.swift
//  StudySync
//
//  Created by mp on 18.12.2025.
//

import Foundation
import SwiftData

@Model
class StudyPackage: Identifiable {
    var id: UUID
    var name: String
    var colorHex: String
    var icon: String
    var dateCreated: Date
    
    @Relationship(deleteRule: .cascade) var groups: [StudyGroup] = []
    
    init(name: String, colorHex: String = "blue", icon: String = "book.fill") {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
        self.icon = icon
        self.dateCreated = Date()
    }
}
