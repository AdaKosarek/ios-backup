//
//  StudySync_WatchApp.swift
//  StudySync Watch Watch App
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

@main
struct StudySync_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
           // WatchContentView()
        }
        .modelContainer(for: [
            StudyPackage.self,
            StudyGroup.self,  // Přidáno
            StudyCard.self,   // Přidáno
            StudySession.self,
            
        ])
    }
}
