//
//  WatchContentView.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI

struct WatchContentView: View {
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            WatchStatsView()
                .tag(0)
            
            WatchDashboardView()
                .tag(1)
            
            WatchSettingsView()
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .watchBackground() 
    }
}
