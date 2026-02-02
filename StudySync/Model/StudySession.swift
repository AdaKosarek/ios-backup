//
//  StudySession.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import Foundation
import SwiftData

@Model
class StudySession {
    var id: UUID
    var date: Date
    var correctCount: Int
    var incorrectCount: Int
    
    var totalCards: Int {
        correctCount + incorrectCount
    }
    
    var accuracy: Double {
        guard totalCards > 0 else { return 0 }
        return Double(correctCount) / Double(totalCards) * 100
    }
    
    init(correctCount: Int, incorrectCount: Int) {
        self.id = UUID()
        self.date = Date()
        self.correctCount = correctCount
        self.incorrectCount = incorrectCount
    }
}
