//
//  PackageDetailView.swift
//  StudySync
//

import SwiftUI

struct PackageDetailView: View {
    @State var viewModel: PackageDetailViewModel
    @EnvironmentObject var diContainer: DIContainer
    
    // Stavy pro modální okna
    @State private var showingStudySession = false
    @State private var showingAddGroupAlert = false
    @State private var newGroupName = ""
    
    var body: some View {
        ZStack {
            // 1. VRSTVA: Animované pozadí
            BackgroundBlob()
                .ignoresSafeArea()
            
            // 2. VRSTVA: Obsah
            ScrollView {
                LazyVStack(spacing: 16) {
                    
                    // 1. Sekce: Hlavička a Akce
                    headerSection
                    
                    // 2. Sekce: Seznam Skupin
                    groupsListSection
                }
                .padding(.bottom, 20)
            }
            // Zprůhlednění ScrollView
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        // Nastavení navigace
        .navigationTitle(viewModel.package.name)
        .toolbar {
            Button(action: { showingAddGroupAlert = true }) {
                Image(systemName: "plus")
            }
            .accessibilityIdentifier("addGroupButton")
        }
        .alert("Nová skupina", isPresented: $showingAddGroupAlert) {
            TextField("Název", text: $newGroupName)
                .accessibilityIdentifier("newGroupNameField")
            Button("Vytvořit") {
                viewModel.addGroup(name: newGroupName)
                newGroupName = ""
            }
            .accessibilityIdentifier("confirmAddGroupButton")
            Button("Zrušit", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showingStudySession) {
            NavigationStack {
                SessionView(viewModel: diContainer.makeSessionViewModel(cards: viewModel.allCards))
            }
        }
    }
    
    // MARK: - Subviews (Rozdělení kódu)
    
    // Sekce s počtem karet a tlačítkem Play
    @ViewBuilder
    private var headerSection: some View {
        if !viewModel.allCards.isEmpty {
            HStack {
                VStack(alignment: .leading) {
                    Text("Celkem karet")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.allCards.count)")
                        .font(.title2)
                        .bold()
                }
                
                Spacer()
                
                Button(action: { showingStudySession = true }) {
                    HStack {
                        Text("Studovat vše")
                        Image(systemName: "play.fill")
                    }
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(hex: viewModel.package.colorHex).gradient)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .shadow(color: Color(hex: viewModel.package.colorHex).opacity(0.4), radius: 5, y: 3)
                }
                .accessibilityIdentifier("playSessionButton")
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
    
    // Sekce se seznamem skupin
        @ViewBuilder
        private var groupsListSection: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Skupiny")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                if viewModel.package.groups.isEmpty {
                    ContentUnavailableView(
                        "Žádné skupiny",
                        systemImage: "folder.badge.questionmark",
                        description: Text("Přidej novou skupinu tlačítkem +")
                    )
                    .padding(.top, 20)
                } else {
                    VStack(spacing: 16) {
                        ForEach(viewModel.package.groups) { group in
                            groupRow(for: group)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    
    // Samostatný řádek skupiny
    private func groupRow(for group: StudyGroup) -> some View {
        NavigationLink(destination: CardListView(viewModel: diContainer.makeCardListViewModel(group: group))) {
            GroupCardView(group: group, themeColorHex: viewModel.package.colorHex)
        }
        // Aplikace 3D efektu
        //.simple3D()
        
        .contextMenu {
            Button(role: .destructive) {
                // Voláme ViewModel přímo
                viewModel.deleteGroup(group)
            } label: {
                Label("Smazat skupinu", systemImage: "trash")
            }
        }
        .accessibilityIdentifier("groupRow_\(group.name)")
    }
}
