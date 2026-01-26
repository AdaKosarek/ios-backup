//
//  PackagesListView.swift
//  StudySync
//

import SwiftUI

struct PackagesListView: View {
    @State var viewModel: PackagesListViewModel
    @EnvironmentObject var diContainer: DIContainer
    
    @State private var showingAddSheet = false
    @State private var packageToEdit: StudyPackage?
    
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundBlob().ignoresSafeArea()
                
                ScrollView {
                    listContent
                        .padding()
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("Moje Balíčky")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // Tlačítko pro přidání nového balíčku
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill").font(.title2)
                    }
                    .accessibilityIdentifier("addPackageButton")
                }
            }
            .sheet(isPresented: $showingAddSheet, onDismiss: {
                viewModel.loadPackages()
            }) {
                EditPackageView(
                    viewModel: diContainer.makeEditPackageViewModel(package: nil)
                )
                .presentationDetents([.medium])
            }
            .sheet(item: $packageToEdit, onDismiss: {
                viewModel.loadPackages()
            }) { package in
                EditPackageView(
                    viewModel: diContainer.makeEditPackageViewModel(package: package)
                )
                .presentationDetents([.medium])
            }
            .onAppear {
                viewModel.loadPackages()
            }
        }
        .tint(selectedTheme.mainColor)
    }
    
    
    @ViewBuilder
    private var listContent: some View {
        LazyVStack(spacing: 16) {
            if viewModel.packages.isEmpty {
                ContentUnavailableView("Žádné balíčky", systemImage: "tray.fill")
                    .accessibilityIdentifier("packagesEmptyState")
                    .padding(.top, 50)
            } else {
                ForEach(viewModel.packages) { package in
                    packageRow(for: package)
                }
            }
        }.accessibilityIdentifier("packagesList")
    }
    
    private func packageRow(for package: StudyPackage) -> some View {
        NavigationLink(destination: PackageDetailView(viewModel: diContainer.makePackageDetailViewModel(package: package))) {
            PackageCardView(package: package)
        }
        .accessibilityIdentifier("packageRow_\(package.id.uuidString)") 
        .contextMenu {
            Button {
                packageToEdit = package
            } label: {
                Label("Upravit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                deletePackage(package)
            } label: {
                Label("Smazat balíček", systemImage: "trash")
            }
        }
    }
    
    private func deletePackage(_ package: StudyPackage) {
        viewModel.deletePackage(package)
    }
}
