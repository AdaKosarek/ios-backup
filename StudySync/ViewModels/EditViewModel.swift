//
//  EditViewModel.swift
//  StudySync
//
//  Created by mp on 21.01.2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
class EditPackageViewModel {
    var name: String = ""
    var selectedColorHex: String = "blue"
    
    let availableColors = ["blue", "red", "green", "orange", "purple", "pink", "yellow", "gray"]
    
    private var packageToEdit: StudyPackage?
    private let dataService: DataServiceProtocol
    
    var title: LocalizedStringKey {
        packageToEdit == nil ? "new_pack" : "edit_pack"
    }
    
    var buttonTitle: LocalizedStringKey {
        packageToEdit == nil ? "create" : "save"
    }
    
    init(package: StudyPackage? = nil, dataService: DataServiceProtocol) {
        self.packageToEdit = package
        self.dataService = dataService
        
        // Pokud editujeme, předvyplníme data
        if let package = package {
            self.name = package.name
            self.selectedColorHex = package.colorHex
        }
    }
    
    func save() {
        if let package = packageToEdit {
            package.name = name
            package.colorHex = selectedColorHex
            
        } else {
            let newPackage = StudyPackage(
                name: name,
                colorHex: selectedColorHex,
                icon: "book.closed.fill"
            )
            dataService.addPackage(newPackage)
        }
    }
    
    func mapColor(_ name: String) -> Color {
        switch name {
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "yellow": return .yellow
        case "gray": return .gray
        default: return .blue
        }
    }
}
