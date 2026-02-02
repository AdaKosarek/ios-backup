//
//  ListViewModel.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import SwiftUI
import Observation
import CoreLocation
import CoreData

@Observable
class ListViewModel{
    var state: ListViewState = ListViewState()
    
    private var dataManager: DataManaging
    private let geocodingManager: GeocodingManaging
    private let locationManager: LocationManaging
    
    private var periodicUpdatesRunning = false //pro lokaci

    init(
        dataManager: DataManaging,
        geocodingManager: GeocodingManaging,
        locationManager: LocationManaging
    ) {
        self.dataManager = dataManager
        self.geocodingManager = geocodingManager
        self.locationManager = locationManager
    }
}

extension ListViewModel {
    //ADD
    func addEntry(
        name: String,
        type: EntryType,
        date: Date,
        coordinates: CLLocationCoordinate2D,
        locationName: String,
        rating: Int16
    ) {
        let building = Building(context: dataManager.context)

        building.id = UUID()
        building.name = name
        building.type = type.rawValue
        building.date = date
        building.availability = true
        building.rating = 0
        building.counter = 0
        building.latitude = coordinates.latitude
        building.longitude = coordinates.longitude
        building.locationName = locationName
        building.rating = rating

        dataManager.saveBuilding(building: building)
        fetchEntries()
    }
    
    //picker
    func resolvePlaceName(
        from coordinates: CLLocationCoordinate2D,
        completion: @escaping (String) -> Void
    ) {
        geocodingManager.placeName(from: coordinates) { name in
            DispatchQueue.main.async {
                completion(name ?? "Unknown location")
            }
        }
    }
    
    //LIST
    func fetchEntries() {
        let buildings: [Building] = dataManager.fetchBuildings()
        
        state.entries = buildings.map {
            
            return Entry(
                id: $0.id ?? UUID(),
                name: $0.name ?? "No name",
                type: EntryType(rawValue: $0.type) ?? .Resort,
                date: $0.date ?? Date(),
                availability: $0.availability,
                rating: $0.rating,
                counter: $0.counter,
                coordinates: .init(latitude: $0.latitude, longitude: $0.longitude ),
                locationName: $0.locationName ?? "No location"
            )
        }
    }
    
    //lokace
    func syncLocation() {
        state.mapCameraPosition = locationManager.cameraPosition
    }
    
    func startPeriodicLocationUpdate() async {
        if !periodicUpdatesRunning {
            periodicUpdatesRunning.toggle()
            
            while true {
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                syncLocation()
            }
        }
    }
}
