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
    var score: Int
    
    init(score: Int) {
        self.id = UUID()
        self.date = Date()
        self.score = score
    }
}
