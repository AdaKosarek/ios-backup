//
//  EditViewModel.swift
//  StudySync
//
//  Created by Martin Reich on 21.01.2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
class EditPackageViewModel {
    // Data formuláře
    var name: String = ""
    var selectedColorHex: String = "blue"
    
    // Konstanty
    let availableColors = ["blue", "red", "green", "orange", "purple", "pink", "yellow", "gray"]
    
    // Privátní vlastnosti
    private var packageToEdit: StudyPackage?
    private let dataService: DataServiceProtocol
    
    // Computovaná vlastnost pro nadpis View
    var title: LocalizedStringKey {
        packageToEdit == nil ? "new_pack" : "edit_pack"
    }
    
    var buttonTitle: LocalizedStringKey {
        packageToEdit == nil ? "create" : "save"
    }
    
    // --- INIT ---
    init(package: StudyPackage? = nil, dataService: DataServiceProtocol) {
        self.packageToEdit = package
        self.dataService = dataService
        
        // Pokud editujeme, předvyplníme data
        if let package = package {
            self.name = package.name
            self.selectedColorHex = package.colorHex
        }
    }
    
    // --- ULOŽENÍ ---
    func save() {
        if let package = packageToEdit {
            // 1. REŽIM EDITACE: Aktualizujeme existující objekt
            // Protože StudyPackage je třída (@Model) ve SwiftData, stačí změnit vlastnosti.
            // Kontext se uloží automaticky nebo při dalším save.
            package.name = name
            package.colorHex = selectedColorHex
            
            // Pokud vaše DataService má metodu update, zavolejte ji (pro vynucení uložení)
            // dataService.saveContext()
        } else {
            // 2. REŽIM VYTVÁŘENÍ: Vytvoříme nový objekt
            let newPackage = StudyPackage(
                name: name,
                colorHex: selectedColorHex,
                icon: "book.closed.fill"
            )
            dataService.addPackage(newPackage)
        }
    }
    
    // Pomocná funkce pro barvy
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
