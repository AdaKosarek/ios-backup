//
//  StudySyncWApp.swift
//  StudySyncW Watch App
//
//  Created by mp on 23.01.2026.
//
import SwiftUI
import SwiftData

@main
struct StudySyncW_Watch_AppApp: App {
    init() {
        _ = WatchConnector.shared
    }
    
    var body: some Scene {
        WindowGroup {
            WatchContentView()
        }
        .modelContainer(for: [
            StudyPackage.self,
            StudyGroup.self,  // Přidáno
            StudyCard.self,   // Přidáno
            StudySession.self,
            
        ])
    }
}
