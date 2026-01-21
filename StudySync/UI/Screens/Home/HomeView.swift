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
            ZStack {
                // 1. VRSTVA: Animované pozadí
                BackgroundBlob()
                    .ignoresSafeArea()
                
                // 2. VRSTVA: Obsah
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // 1. Widget denního cíle
                        DailyGoalWidget(cardsStudiedToday: viewModel.cardsStudiedToday)
                            .padding(.horizontal)
                            .simple3D() // 3D Efekt
                        
                        // 2. Nadpis sekce
                        HStack {
                            Text("Rychlý přehled")
                                .font(.headline)
                                .foregroundStyle(.secondary) // Lepší barva pro nadpis
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // 3. Mřížka se statistikami
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            
                            StatCard(
                                                        title: "Série",
                                                        value: "\(viewModel.streak)",
                                                        unit: "dní",
                                                        iconType: .flame,
                                                        color: .orange
                            ).simple3D()
                                                    
                                                    // 2. Zkušenosti -> HVĚZDA
                                                    StatCard(
                                                        title: "Zkušenosti",
                                                        value: "\(viewModel.totalXP)",
                                                        unit: "XP",
                                                        iconType: .star,
                                                        color: .yellow
                                                    ).simple3D()
                                                    
                                                    // 3. Další studium -> GRAF (Symbolizuje plán/statistiku)
                                                    StatCard(
                                                        title: "Další studium",
                                                        value: "2",
                                                        unit: "hod",
                                                        iconType: .chart,
                                                        color: .purple
                                                    ).simple3D()
                                                    
                                                    // 4. Dnes hotovo -> TERČ (Symbolizuje splněný cíl)
                                                    StatCard(
                                                        title: "Dnes hotovo",
                                                        value: "\(viewModel.cardsStudiedToday)",
                                                        unit: "karet",
                                                        iconType: .target,
                                                        color: .green
                                                    ).simple3D()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                // DŮLEŽITÉ: Zprůhlednění ScrollView, aby byla vidět animace
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("Dnes")
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}
