//
//  HomeView.swift
//  StudySync
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // 1. Widget denního cíle
                    DailyGoalWidget(cardsStudiedToday: viewModel.cardsStudiedToday)
                        .padding(.horizontal)
                    
                    // 2. Nadpis sekce (Volitelné)
                    HStack {
                        Text("Rychlý přehled")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // 3. Mřížka se statistikami (Používá sdílenou StatCard)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        
                        StatCard(
                            title: "Série",
                            value: "\(viewModel.streak)",
                            unit: "dní",
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Zkušenosti",
                            value: "\(viewModel.totalXP)",
                            unit: "XP",
                            icon: "star.fill",
                            color: .yellow
                        )
                        
                        // Zde je statický údaj, pokud ho nemáš v modelu, necháme ho takto
                        StatCard(
                            title: "Další studium",
                            value: "2",
                            unit: "hod",
                            icon: "clock.fill",
                            color: .purple
                        )
                        
                        StatCard(
                            title: "Dnes hotovo",
                            value: "\(viewModel.cardsStudiedToday)",
                            unit: "karet",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color(UIColor.systemGroupedBackground)) // Sjednocené pozadí
            .navigationTitle("Dnes")
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}
