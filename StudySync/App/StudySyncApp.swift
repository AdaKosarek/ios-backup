//
//  StudySyncApp.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

@main
struct StudySyncApp: App {
    let modelContainer: ModelContainer
    let diContainer: DIContainer
    
    init() {
        do {
            let schema = Schema([StudyPackage.self, StudySession.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.modelContainer = try ModelContainer(for: schema, configurations: [config])
            
            // --- UI TEST LOGIKA ---
            // Pokud spouštíme UI Testy, použijeme MockDataService
            if CommandLine.arguments.contains("--mock-data") {
                let mockService = MockDataService()
                // Předvyplníme data pro testy
                mockService.addMockDataForUITests()
                self.diContainer = DIContainer(dataService: mockService)
            } else {
                // Produkční režim: Reálná databáze
                let dataService = SwiftDataService(modelContext: modelContainer.mainContext)
                self.diContainer = DIContainer(dataService: dataService)
            }
            
        } catch {
            fatalError("Failed to init ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(diContainer)
        }
        .modelContainer(modelContainer)
    }
}
