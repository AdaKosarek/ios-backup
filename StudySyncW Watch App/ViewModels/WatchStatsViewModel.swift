//
//  WatchStatsViewModel.swift
//  StudySync
//
//  Created by mp on 24.01.2026.
//
import SwiftUI
import SwiftData

@Observable
class WatchStatsViewModel {

    private let connector: WatchConnector

    init(connector: WatchConnector = .shared) {
        self.connector = connector
    }

    var accuracyProgress: Double {
        (connector.receivedStats?.accuracy ?? 0) / 100.0
    }

    var accuracyText: String {
        "\(Int(connector.receivedStats?.accuracy ?? 0))%"
    }

    var xpToday: Int {
        connector.receivedStats?.xpToday ?? 0
    }
    var xpAll: Int {
        connector.receivedStats?.xpAll ?? 0
    }
    var streakDays: Int {
        connector.receivedStats?.streakDays ?? 0
    }

    var weeklyCards: [Int] {
        let data = connector.receivedStats?.weeklyCards
            ?? Array(repeating: 0, count: 7)

        guard data.count == 7 else { return data }

        //den zpět
        return Array(data.dropFirst()) + [data.first!]
    }

}
