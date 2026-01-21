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
    // 1. Načítání nastavení
    @AppStorage("selectedLanguage") private var selectedLanguage: AppLanguage = .czech
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
    
    // 2. NOVÉ: Stav pro zobrazení Splash Screenu
    @State private var showSplashScreen = true
    
    @Environment(\.scenePhase) private var scenePhase
    
    // Definice SwiftData kontejneru
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
        // --- Logika pro UI Testy a SwiftData (Zachováno) ---
        if CommandLine.arguments.contains("--mock-data") {
            print("🚀 UI Test Mode: Aktivuji Mock Data...")
            let mockService = MockDataService()
            mockService.addMockDataForUITests()
            self.diContainer = DIContainer(dataService: mockService)
        } else {
            print("📱 Normal Mode: Aktivuji SwiftData...")
            let dataService = SwiftDataService(modelContext: sharedModelContainer.mainContext)
            self.diContainer = DIContainer(dataService: dataService)
        }
        
        _ = WatchConnector.shared
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                // A) HLAVNÍ APLIKACE (Zobrazí se, až splash zmizí)
                if !showSplashScreen {
                    MainTabView()
                        .environmentObject(diContainer)
                        // Aplikace nastavení vzhledu a jazyka
                        .tint(selectedTheme.mainColor)
                        .environment(\.locale, .init(identifier: selectedLanguage.rawValue))
                        .accentColor(selectedTheme.mainColor)
                        // Plynulý přechod při objevení
                        .transition(.opacity)
                }
                
                // B) SPLASH SCREEN (Je nahoře, dokud neskončí)
                if showSplashScreen {
                    SplashScreenView(isFinished: $showSplashScreen)
                        .transition(.opacity) // Plynulé zmizení
                        .zIndex(1) // Zajistí, že je vždy nahoře
                }
            }
            // Animace přepnutí mezi Splashem a Aplikací
            .animation(.easeInOut(duration: 0.5), value: showSplashScreen)
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
