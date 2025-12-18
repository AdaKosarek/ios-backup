//
//  PackagesListView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

struct PackagesListView: View {
    // Automaticky načte všechny balíčky seřazené podle data vytvoření
    @Query(sort: \StudyPackage.dateCreated, order: .reverse) private var packages: [StudyPackage]
    
    // Potřebujeme přístup k databázi pro mazání/vkládání
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                if packages.isEmpty {
                    ContentUnavailableView(
                        "Žádné balíčky",
                        systemImage: "tray.fill",
                        description: Text("Klikni na + a vytvoř svůj první studijní balíček.")
                    )
                } else {
                    ForEach(packages) { package in
                        NavigationLink(destination: PackageDetailView(package: package)) {
                            HStack {
                                // Ikonka balíčku
                                Image(systemName: package.icon)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .frame(width: 50, height: 50)
                                    .background(
                                    package.colorHex == "red" ? Color.red :
                                    package.colorHex == "green" ? Color.green :
                                    package.colorHex == "orange" ? Color.orange :
                                    package.colorHex == "purple" ? Color.purple :
                                    package.colorHex == "pink" ? Color.pink :
                                    Color.blue
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading) {
                                    Text(package.name)
                                        .font(.headline)
                                    Text("\(package.groups.count) skupin")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deletePackage)
                }
            }
            .navigationTitle("Moje Balíčky")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                EditPackageView()
                VStack {
                    Text("Nový balíček")
                    Button("Přidat testovací data") {
                        addMockData()
                        showingAddSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    // Funkce pro smazání tažením prstu
    private func deletePackage(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(packages[index])
            }
        }
    }
    
    // Dočasná funkce pro rychlé otestování
    private func addMockData() {
        let newPackage = StudyPackage(name: "Matematika", icon: "function")
        modelContext.insert(newPackage)
        
        let newPackage2 = StudyPackage(name: "Angličtina", icon: "globe")
        modelContext.insert(newPackage2)
    }
}

#Preview {
    PackagesListView()
        .modelContainer(for: StudyPackage.self, inMemory: true)
}
