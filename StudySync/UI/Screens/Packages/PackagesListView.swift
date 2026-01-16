//
//  PackagesListView.swift
//  StudySync
//

import SwiftUI

struct PackagesListView: View {
    @State var viewModel: PackagesListViewModel
    @EnvironmentObject var diContainer: DIContainer
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Pozadí celé obrazovky (aby bílé kartičky vynikly)
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    // 2. LazyVStack místo Listu pro flexibilní design
                    LazyVStack(spacing: 16) {
                        
                        if viewModel.packages.isEmpty {
                            // Prázdný stav
                            ContentUnavailableView("Žádné balíčky", systemImage: "tray.fill")
                                .padding(.top, 50)
                                .accessibilityIdentifier("EmptyPackagesView")
                        } else {
                            // 3. Smyčka přes balíčky
                            ForEach(viewModel.packages) { package in
                                NavigationLink(destination: PackageDetailView(viewModel: diContainer.makePackageDetailViewModel(package: package))) {
                                    
                                    // Voláme oddělenou komponentu kartičky
                                    PackageCardView(package: package)
                                    
                                }
                                .buttonStyle(PlainButtonStyle()) // Důležité: Odstraní modrý efekt při kliknutí
                                
                                // 4. Mazání: Kontextové menu (dlouhé podržení)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        if let index = viewModel.packages.firstIndex(of: package) {
                                            viewModel.deletePackage(at: IndexSet(integer: index))
                                        }
                                    } label: {
                                        Label("Smazat balíček", systemImage: "trash")
                                    }
                                }
                                // DŮLEŽITÉ PRO TESTY: Identifikátor musí být na prvku, na který se kliká
                                .accessibilityIdentifier("PackageRow_\(package.name)")
                            }
                        }
                    }
                    .padding() // Odsazení obsahu od krajů
                }
            }
            .navigationTitle("Moje Balíčky")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityIdentifier("AddPackageButton")
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sync Watch") {
                        viewModel.syncToWatch()
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddPackageSheet(onSave: { name, color in
                    viewModel.addPackage(name: name, color: color, icon: "book.closed.fill")
                    showingAddSheet = false
                })
            }
            .onAppear {
                viewModel.loadPackages()
            }
        }
    }
}



// MARK: - Add Package Sheet (Formulář pro přidání)
struct AddPackageSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var selectedColor = "blue"
    
    let availableColors = ["blue", "red", "green", "orange", "purple", "pink", "yellow", "gray"]
    var onSave: (String, String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                
                // Input pro název
                VStack(alignment: .leading, spacing: 8) {
                    Text("Název balíčku")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    TextField("Např. Angličtina", text: $name)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .accessibilityIdentifier("packageNameField")
                }
                
                // Výběr barvy
                VStack(alignment: .leading, spacing: 12) {
                    Text("Barva")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(availableColors, id: \.self) { colorName in
                            Circle()
                                .fill(Color(hex: colorName).gradient)
                                .frame(height: 44)
                                .overlay {
                                    if selectedColor == colorName {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                }
                                .onTapGesture {
                                    withAnimation(.spring) {
                                        selectedColor = colorName
                                    }
                                }
                                .accessibilityIdentifier("color_\(colorName)")
                        }
                    }
                }
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Nový balíček")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Vytvořit") {
                        onSave(name, selectedColor)
                    }
                    .disabled(name.isEmpty)
                    .bold()
                    .accessibilityIdentifier("createPackageButton")
                }
            }
        }
        .presentationDetents([.medium])
    }
}
