//
//  DetailViewModel.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//
import SwiftUI
import Observation
import CoreLocation
import CoreData

@Observable
final class DetailViewModel {
    var state: DetailViewState
    private let dataManager: DataManaging
    private let connector: PhoneConnecting

    init(
        entry: Entry,
        dataManager: DataManaging,
        connector: PhoneConnecting
    ) {
        self.state = DetailViewState(entry: entry)
        self.dataManager = dataManager
        self.connector = connector
    }
}

extension DetailViewModel {
    func incrementCounter() {
        let entryId = state.entry.id

        // 1️⃣ Core Data (watchOS)
        guard let building = dataManager.fetchBuildingWithId(id: entryId) else {
            return
        }

        building.counter += 1
        dataManager.saveBuilding(building: building)

        // 2️⃣ Aktualizace lokálního state (UI)
        state.entry.counter = building.counter

        // 3️⃣ Odeslání změny na iOS
        connector.sendIncrementCounter(id: entryId)
    }
}
