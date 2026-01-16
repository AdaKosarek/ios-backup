//
//  MainTabView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

//
//  MainTabView.swift
//  StudySync
//

import SwiftUI

struct MainTabView: View {
    // Získám kontejner z prostředí (vloženo v StudySyncApp)
    @EnvironmentObject var diContainer: DIContainer
    
    var body: some View {
        TabView {
            // 1. Domů
            HomeView(viewModel: HomeViewModel(dataService: diContainer.dataService))
                .tabItem {
                    Label("Dnes", systemImage: "house")
                }
                .tag(0)
            
            // 2. Knihovna (Balíčky)
            PackagesListView(viewModel: PackagesListViewModel(dataService: diContainer.dataService))
                .tabItem {
                    Label("Knihovna", systemImage: "books.vertical")
                }
                .tag(1)
                // --- TOTO ZDE CHYBĚLO PRO TESTY ---
                .accessibilityIdentifier("LibraryTab")
            
            // 3. Statistiky
            StatisticsView(viewModel: StatisticsViewModel(dataService: diContainer.dataService))
                .tabItem {
                    Label("Statistiky", systemImage: "chart.bar")
                }
                .tag(2)
                .accessibilityIdentifier("StatsTab")
            
            // 4. Nastavení
            SettingsView()
                .tabItem {
                    Label("Nastavení", systemImage: "gear")
                }
                .tag(3)
                .accessibilityIdentifier("SettingsTab")
        }
    }
}
