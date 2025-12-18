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
    // Tady definujeme, jaké modely (tabulky) databáze obsahuje
    // Zatím tam dáme jen hlavní StudyPackage, ostatní (Group, Card) se chytnou automaticky díky vazbám.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StudyPackage.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView() // Tady spouštíme tvůj nový TabBar
        }
        .modelContainer(sharedModelContainer) // A tady posíláme databázi do celé appky
    }
}
