//
//  DataManaging.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import CoreData
import UIKit

protocol DataManaging {
    var context: NSManagedObjectContext { get }
    
    func saveBuilding(building: Building)
    func removeBuilding(building: Building)
    func fetchBuildings() -> [Building]
    func fetchBuildingWithId(id: UUID) -> Building?
}
