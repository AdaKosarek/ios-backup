//
//  PackagesListView.swift
//  StudySync
//

import SwiftUI

struct PackagesListView: View {
    @State var viewModel: PackagesListViewModel
    @EnvironmentObject var diContainer: DIContainer
    
    // Stav pro vytvoření nového balíčku
    @State private var showingAddSheet = false
    
    // Stav pro editaci existujícího balíčku
    @State private var packageToEdit: StudyPackage?
    
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue

    var body: some View {
        NavigationStack {
            ZStack {
                // Pozadí
                BackgroundBlob().ignoresSafeArea()
                
                ScrollView {
                    // Obsah seznamu
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
            
            // 1. SHEET: Přidání nového balíčku
            // OPRAVA 1: onDismiss zajistí načtení dat po zavření okna
            .sheet(isPresented: $showingAddSheet, onDismiss: {
                viewModel.loadPackages()
            }) {
                EditPackageView(
                    viewModel: diContainer.makeEditPackageViewModel(package: nil)
                )
                // OPRAVA 2: Okno bude jen do poloviny obrazovky
                .presentationDetents([.medium])
            }
            
            // 2. SHEET: Editace existujícího balíčku
            // OPRAVA 1: onDismiss zajistí načtení dat po zavření okna
            .sheet(item: $packageToEdit, onDismiss: {
                viewModel.loadPackages()
            }) { package in
                EditPackageView(
                    viewModel: diContainer.makeEditPackageViewModel(package: package)
                )
                // OPRAVA 2: Okno bude jen do poloviny obrazovky
                .presentationDetents([.medium])
            }
            .onAppear {
                viewModel.loadPackages()
            }
        }
        .tint(selectedTheme.mainColor)
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var listContent: some View {
        LazyVStack(spacing: 16) {
            if viewModel.packages.isEmpty {
                ContentUnavailableView("Žádné balíčky", systemImage: "tray.fill")
                    .padding(.top, 50)
            } else {
                ForEach(viewModel.packages) { package in
                    packageRow(for: package)
                }
            }
        }
    }
    
    private func packageRow(for package: StudyPackage) -> some View {
        NavigationLink(destination: PackageDetailView(viewModel: diContainer.makePackageDetailViewModel(package: package))) {
            PackageCardView(package: package)
        }
        
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
