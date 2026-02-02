//
//  PackageDetailView.swift
//  StudySync
//

import SwiftUI

struct PackageDetailView: View {
    @State var viewModel: PackageDetailViewModel
    @EnvironmentObject var diContainer: DIContainer
    
    @State private var showingStudySession = false
    @State private var showingAddGroupAlert = false
    @State private var newGroupName = ""
    @State private var showingQR = false

    
    var body: some View {
        ZStack {
            BackgroundBlob()
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    headerSection
                    groupsListSection
                }
                .padding(.bottom, 20)
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle(viewModel.package.name)
        .toolbar {
            Button {
                showingQR = true
            } label: {
                Image(systemName: "qrcode")
            }
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
        .sheet(isPresented: $showingQR) {
            PackageQRExportView(
                package: viewModel.package,
                exportService: diContainer.makePackageExportService()
            )
            .presentationDetents([.medium])
        }

    }

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
    
    private func groupRow(for group: StudyGroup) -> some View {
        NavigationLink(destination: CardListView(viewModel: diContainer.makeCardListViewModel(group: group))) {
            GroupCardView(group: group, themeColorHex: viewModel.package.colorHex)
        }
        
        .contextMenu {
            Button(role: .destructive) {
                viewModel.deleteGroup(group)
            } label: {
                Label("Smazat skupinu", systemImage: "trash")
            }
        }
        .accessibilityIdentifier("groupRow_\(group.name)")
    }
}
