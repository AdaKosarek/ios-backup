//
//  ContentView.swift
//  FinanceManager
//
//  Created by mp on 09.06.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isSheetPresented = false

    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    HomeView(isSheetPresented: $isSheetPresented)
                case 1:
                    OverviewView(isSheetPresented: $isSheetPresented)
                case 2:
                    StatisticsView(isSheetPresented: $isSheetPresented)
                case 3:
                    SettingsView()
                default:
                    HomeView(isSheetPresented: $isSheetPresented)
                }
            }

            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab, isSheetPresented: $isSheetPresented)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isSheetPresented) {
            NewTransactionView(isPresented: $isSheetPresented)
        }
    }
}



#Preview {
    ContentView()
}
