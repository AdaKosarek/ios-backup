//
//  MainTabView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // 1. Home
            HomeView() // Zatím tam dáme jen toto, hned to vytvoříme
                .tabItem {
                    Label("Today", systemImage: "house.fill")
                }
            
            // 2. Packages
            PackagesListView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
            
            // 3. Stats
            Text("Statistics")
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.xaxis")
                }
            
            // 4. Settings
            SettingsView() // Odkaz na nastavení
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.blue) // Barva aktivní ikonky
    }
}
