//
//  StudyCard.swift
//  StudySync
//
//  Created by mp on 18.12.2025.
//

import Foundation
import SwiftData

@Model
class StudyCard {
    var id: UUID
    var question: String
    var answer: String
    var dateCreated: Date
    
    var successfulAttempts: Int = 0
    var failedAttempts: Int = 0
    var lastReviewed: Date?
    
    var group: StudyGroup?
    
    init(question: String, answer: String) {
        self.id = UUID()
        self.question = question
        self.answer = answer
        self.dateCreated = Date()
    }
}
