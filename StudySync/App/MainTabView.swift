//
//  MainTabView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

struct MainTabView: View {
    // Přístup k DI kontejneru
    @EnvironmentObject var diContainer: DIContainer
    
    var body: some View {
        TabView {
            // 1. Domů
            HomeView(viewModel: diContainer.makeHomeViewModel())
                .tabItem {
                    Label("Today", systemImage: "house.fill")
                }
                .tag(0)
                .accessibilityIdentifier("HomeTab") // ID pro testy
            
            // 2. Knihovna
            PackagesListView(viewModel: diContainer.makePackagesListViewModel())
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
                .tag(1)
                .accessibilityIdentifier("LibraryTab") // <--- TOTO HLEDÁ TVŮJ TEST
            
            // 3. Statistiky
            StatisticsView(viewModel: diContainer.makeStatisticsViewModel())
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.xaxis")
                }
                .tag(2)
                .accessibilityIdentifier("StatsTab") // ID pro testy
            
            // 4. Nastavení
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
                .accessibilityIdentifier("SettingsTab") // ID pro testy
        }
        // ZDE JSME SMAZALI .tint(.blue)
        // Barva se nyní řídí v StudySyncApp.swift, takže tady
        // nic nenastavujeme, aby se projevila volba uživatele.
    }
}
