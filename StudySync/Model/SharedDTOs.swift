//
//  SharedDTOs.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation

// DTO = Data Transfer Object (objekt pro přenos dat)

struct PackageDTO: Codable, Identifiable {
    let id: UUID
    let name: String
    let colorHex: String
    let groups: [GroupDTO]
}

struct GroupDTO: Codable, Identifiable {
    let id: UUID
    let name: String
    let cards: [CardDTO]
}

struct CardDTO: Codable, Identifiable {
    let id: UUID
    let question: String
    let answer: String
}

// Struktura pro odeslání výsledku z hodinek zpět do telefonu
struct SessionResultDTO: Codable {
    let correct: Int
    let incorrect: Int
    let date: Date
}

struct WatchStatsDTO: Codable {
    let xpToday: Int
    let xpAll: Int
    let streakDays: Int
    let accuracy: Double
    let weeklyCards: [Int]   // 7 hodnot (Po–Ne)
}
