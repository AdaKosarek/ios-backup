//
//  StudySyncApp.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData
import WatchConnectivity

@main
struct StudySyncApp: App {
    @AppStorage("selectedLanguage") private var selectedLanguage: AppLanguage = .czech
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
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

    
    //!
    init() {
        let dataService: DataServiceProtocol
        if CommandLine.arguments.contains("--ui-testing") {
            showSplashScreen = false
        }
        if CommandLine.arguments.contains("--mock-data") {
            let mockService = MockDataService()
            mockService.addMockDataForUITests()
            dataService = mockService
            self.diContainer = DIContainer(dataService: mockService)
        } else {
            let realService = SwiftDataService(
                modelContext: sharedModelContainer.mainContext
            )
            dataService = realService
            self.diContainer = DIContainer(dataService: realService)
        }
        WatchConnector.shared.configure(dataService: dataService)

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
            switch newPhase {

            /*case .active:
                WCSession.default.activate()
                */

            case .background:
                Task { @MainActor in
                    NotificationManager.shared.scheduleEveningNotification(
                        ifNotStudied: sharedModelContainer.mainContext
                    )
                }

            default:
                break
            }
        }

    }
}
