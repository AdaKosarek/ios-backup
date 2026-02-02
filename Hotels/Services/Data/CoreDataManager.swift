//
//  CoreDataManager.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import CoreData

final class CoreDataManager: DataManaging {
    private let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: "Hotels")) {
        self.container = container
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Cannot create persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    
    func saveBuilding(building: Building) {
        save()
    }
    
    //remove
    func removeBuilding(building: Building) {
        context.delete(building)
        save()
    }
    func fetchBuildingWithId(id: UUID) -> Building? {
        let request = NSFetchRequest<Building>(entityName: "Building")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        var buildings: [Building] = []
        
        do {
            buildings = try context.fetch(request)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        
        return buildings.first
    }
    
    func fetchBuildings() -> [Building] {
        let request = NSFetchRequest<Building>(entityName: "Building")
        var buildings: [Building] = []
        
        do {
            buildings = try context.fetch(request)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        return buildings
    }
    
}

private extension CoreDataManager {
    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }
}

