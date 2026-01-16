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
            // Vytváříme View a rovnou mu dáváme ViewModel z kontejneru
            HomeView(viewModel: diContainer.makeHomeViewModel())
                .tabItem { Label("Today", systemImage: "house.fill") }
            
            PackagesListView(viewModel: diContainer.makePackagesListViewModel())
                .tabItem { Label("Library", systemImage: "books.vertical.fill") }
            
            // Stats a Settings zatím necháme jak jsou, nebo implementujeme podobně
            Text("Stats Placeholder").tabItem { Label("Stats", systemImage: "chart.bar.xaxis") }
            Text("Settings Placeholder").tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(.blue)
    }
}
