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
    // 1. Načítání nastavení (Barva a Jazyk)
    @AppStorage("selectedLanguage") private var selectedLanguage: AppLanguage = .czech
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
    
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
        
        // Požádat o notifikace při startu
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            // 2. TADY BYLA CHYBA: Musíš volat MainTabView, ne PackagesListView
            MainTabView()
                .environmentObject(diContainer)
                // 3. Aplikace nastavení vzhledu a jazyka
                .tint(selectedTheme.mainColor)
                .environment(\.locale, .init(identifier: selectedLanguage.rawValue))
        }
        .modelContainer(sharedModelContainer)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                Task { @MainActor in
                    NotificationManager.shared.scheduleEveningNotification(ifNotStudied: sharedModelContainer.mainContext)
                }
            }
        }
    }
}
