//
//  PackagesListViewModel.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import Observation

@Observable
class PackagesListViewModel {
    private let dataService: DataServiceProtocol
    var packages: [StudyPackage] = []
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadPackages()
    }
    
    func loadPackages() {
        do {
            self.packages = try dataService.fetchPackages()
        } catch {
            print("Chyba načítání balíčků: \(error)")
        }
    }
    
    func addPackage(name: String, color: String, icon: String) {
        let newPackage = StudyPackage(name: name, colorHex: color, icon: icon)
        dataService.addPackage(newPackage)
        loadPackages() // Znovu načíst data
    }
    
    func deletePackage(at offsets: IndexSet) {
        for index in offsets {
            let package = packages[index]
            dataService.deletePackage(package)
        }
        loadPackages()
    }
    
    func addMockData() {
        let p1 = StudyPackage(name: "Matematika", colorHex: "blue", icon: "function")
        let p2 = StudyPackage(name: "Angličtina", colorHex: "red", icon: "globe")
        dataService.addPackage(p1)
        dataService.addPackage(p2)
        loadPackages()
    }
}
