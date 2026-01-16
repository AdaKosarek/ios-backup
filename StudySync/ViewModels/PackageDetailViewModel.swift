//
//  PackageDetailViewModel.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import Observation

@Observable
class PackageDetailViewModel {
    private let dataService: DataServiceProtocol
    var package: StudyPackage
    
    init(package: StudyPackage, dataService: DataServiceProtocol) {
        self.package = package
        self.dataService = dataService
    }
    
    func addGroup(name: String) {
        guard !name.isEmpty else { return }
        dataService.addGroup(to: package, name: name)
        // Pozor: Protože 'package' je referenční typ (Class) a SwiftData ho sleduje,
        // UI by se mělo aktualizovat, ale v MVVM je dobré explicitně říct, že se něco změnilo.
    }
    
    func deleteGroup(at offsets: IndexSet) {
        for index in offsets {
            let group = package.groups[index]
            dataService.deleteGroup(group)
        }
    }
    
    var allCards: [StudyCard] {
        package.groups.flatMap { $0.cards }
    }
}
