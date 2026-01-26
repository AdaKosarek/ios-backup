//
//  MainTabView.swift
//  StudySync
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var diContainer: DIContainer
    
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            TabView(selection: $selectedTab) {
                
                HomeView(viewModel: diContainer.makeHomeViewModel())
                    .tag(Tab.home)
                    .toolbar(.hidden, for: .tabBar)
                
                PackagesListView(viewModel: diContainer.makePackagesListViewModel())
                    .tag(Tab.packages)
                    .toolbar(.hidden, for: .tabBar)
                
                StatisticsView(viewModel: diContainer.makeStatisticsViewModel())
                    .tag(Tab.stats)
                    .toolbar(.hidden, for: .tabBar)
                
                SettingsView()
                    .tag(Tab.settings)
                    .toolbar(.hidden, for: .tabBar)
            }
            .ignoresSafeArea(edges: .bottom)
            
            CustomTabBar(selectedTab: $selectedTab, activeColor: currentActiveColor)
        }
        .animation(.easeInOut, value: selectedTheme)
    }
    
    var currentActiveColor: Color {
        return selectedTheme.mainColor
    }
}


