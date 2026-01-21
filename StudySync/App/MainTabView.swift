//
//  MainTabView.swift
//  StudySync
//

import SwiftUI

struct MainTabView: View {
    // Stav pro vybranou záložku
    @State private var selectedTab: Tab = .home
    
    // Přístup k DI kontejneru
    @EnvironmentObject var diContainer: DIContainer
    
    // SLEDUJEME GLOBÁLNÍ BARVU (Stejně jako BackgroundBlob)
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // 1. OBSAH
            TabView(selection: $selectedTab) {
                
                // --- DOMŮ ---
                HomeView(viewModel: diContainer.makeHomeViewModel())
                    .tag(Tab.home)
                    .toolbar(.hidden, for: .tabBar)
                
                // --- BALÍČKY ---
                PackagesListView(viewModel: diContainer.makePackagesListViewModel())
                    .tag(Tab.packages)
                    .toolbar(.hidden, for: .tabBar)
                
                // --- STATISTIKY ---
                StatisticsView(viewModel: diContainer.makeStatisticsViewModel())
                    .tag(Tab.stats)
                    .toolbar(.hidden, for: .tabBar)
                
                // --- NASTAVENÍ ---
                SettingsView()
                    .tag(Tab.settings)
                    .toolbar(.hidden, for: .tabBar)
            }
            .ignoresSafeArea(edges: .bottom)
            
            // 2. VLASTNÍ PLOVOUCÍ NAVIGACE
            // ZDE JE ZMĚNA: Předáváme dynamickou barvu tématu
            CustomTabBar(selectedTab: $selectedTab, activeColor: currentActiveColor)
        }
        // Přidáme animaci změny barvy, aby to bylo plynulé
        .animation(.easeInOut, value: selectedTheme)
    }
    
    // VYLEPŠENÁ LOGIKA BARVY
    var currentActiveColor: Color {
        // Teď nezáleží na tom, na jaké jsme záložce.
        // Vždy vrátíme barvu, kterou má uživatel nastavenou jako globální téma.
        return selectedTheme.mainColor
    }
}


