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
            List {
                if viewModel.packages.isEmpty {
                    ContentUnavailableView("Žádné balíčky", systemImage: "tray.fill")
                        .accessibilityIdentifier("EmptyPackagesView")
                } else {
                    ForEach(viewModel.packages) { package in
                        NavigationLink(destination: PackageDetailView(viewModel: diContainer.makePackageDetailViewModel(package: package))) {
                            HStack {
                                Image(systemName: package.icon)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Color(hex: package.colorHex))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading) {
                                    Text(package.name).font(.headline)
                                    Text("\(package.groups.count) skupin").font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .accessibilityIdentifier("PackageRow_\(package.name)")
                    }
                    .onDelete(perform: viewModel.deletePackage)
                }
            }
            .navigationTitle("Moje Balíčky")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
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

// --- Vylepšený vizuální styl přidávání (podle tvého screenshotu) ---
struct AddPackageSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var selectedColor = "blue"
    
    let availableColors = ["blue", "red", "green", "orange", "purple", "pink", "yellow", "gray"]
    var onSave: (String, String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Sekce Název
                VStack(alignment: .leading, spacing: 8) {
                    Text("Název balíčku")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    TextField("Např. Matematika", text: $name)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .accessibilityIdentifier("packageNameField")
                }
                
                // Sekce Barva
                VStack(alignment: .leading, spacing: 12) {
                    Text("Barva")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    // Vodorovný výběr barev ve dvou řadách nebo mřížce (podle místa)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(availableColors, id: \.self) { colorName in
                            Circle()
                                .fill(Color(hex: colorName))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    if selectedColor == colorName {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                }
                                .onTapGesture {
                                    selectedColor = colorName
                                }
                                .accessibilityIdentifier("color_\(colorName)")
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Nový balíček")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") { dismiss() }
                        .foregroundStyle(.blue)
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
        .presentationDetents([.medium]) // Otevře se jen do poloviny obrazovky
    }
}
