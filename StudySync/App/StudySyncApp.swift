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
    // Sledování stavu aplikace (aktivní / pozadí)
    @Environment(\.scenePhase) private var scenePhase
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StudyPackage.self,
            StudyGroup.self,
            StudyCard.self,
            StudySession.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    let diContainer: DIContainer

    init() {
        let dataService = SwiftDataService(modelContext: sharedModelContainer.mainContext)
        self.diContainer = DIContainer(dataService: dataService)
        
        _ = WatchConnector.shared
        
        // --- 1. PŘIDEJ: Požádat o notifikace při startu ---
        NotificationManager.shared.requestPermission()
        // --------------------------------------------------
    }

    var body: some Scene {
        WindowGroup {
            PackagesListView(viewModel: PackagesListViewModel(dataService: SwiftDataService(modelContext: sharedModelContainer.mainContext)))
                .environmentObject(diContainer)
        }
        .modelContainer(sharedModelContainer)
        // --- 2. PŘIDEJ: Reakce na uspane aplikace ---
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                // Když uživatel zavře aplikaci, zkontrolujeme, zda dnes studoval
                // Pokud NE -> naplánujeme večerní připomínku
                // Pokud ANO -> zrušíme ji (pokud tam nějaká visí)
                // Musíme vytvořit nový kontext nebo použít existující (zde trik s MainActor)
                Task { @MainActor in
                    NotificationManager.shared.scheduleEveningNotification(ifNotStudied: sharedModelContainer.mainContext)
                }
            }
        }
        // -------------------------------------------
    }
}
