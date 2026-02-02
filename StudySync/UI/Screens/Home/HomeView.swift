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
                BackgroundBlob()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        DailyGoalWidget(cardsStudiedToday: viewModel.cardsStudiedToday)
                            .padding(.horizontal)
                            .simple3D()
                        
                        HStack {
                            Text("Rychlý přehled")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            
                            StatCard(
                                                        title: "stat_series",
                                                        value: "\(viewModel.streak)",
                                                        unit: "stat_days",
                                                        iconType: .flame,
                                                        color: .orange
                            ).simple3D()
                                                    
                                                    StatCard(
                                                        title: "stat_ex",
                                                        value: "\(viewModel.totalXP)",
                                                        unit: "XP",
                                                        iconType: .star,
                                                        color: .yellow
                                                    ).simple3D()
                                                    
                                                    StatCard(
                                                        title: "Další studium",
                                                        value: "2",
                                                        unit: "h",
                                                        iconType: .chart,
                                                        color: .purple
                                                    ).simple3D()
                                                    
                                                    StatCard(
                                                        title: "today_done",
                                                        value: "\(viewModel.cardsStudiedToday)",
                                                        unit: "stat_cards",
                                                        iconType: .target,
                                                        color: .green
                                                    ).simple3D()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("today")
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}
