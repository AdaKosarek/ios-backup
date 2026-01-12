//
//  PackagesListView.swift
//  StudySync
//

import SwiftUI
import SwiftData

struct PackagesListView: View {
    @Query(sort: \StudyPackage.dateCreated, order: .reverse) private var packages: [StudyPackage]
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
                    .accessibilityIdentifier("EmptyPackagesView") // PŘIDÁNO
                } else {
                    ForEach(packages) { package in
                        NavigationLink(destination: PackageDetailView(package: package)) {
                            HStack {
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
                        // PŘIDÁNO: Identifikátor pro konkrétní balíček
                        .accessibilityIdentifier("PackageRow_\(package.name)")
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
                    .accessibilityIdentifier("AddPackageButton") // PŘIDÁNO
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                // Pozor: V tvém kódu je EditPackageView i VStack pod ním.
                // Pro testy přidáme ID i testovacímu tlačítku.
                VStack {
                    EditPackageView()
                    Divider()
                    Button("Přidat testovací data") {
                        addMockData()
                        showingAddSheet = false
                    }
                    .accessibilityIdentifier("AddMockDataButton") // PŘIDÁNO
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
    
    private func deletePackage(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(packages[index])
            }
        }
    }
    
    private func addMockData() {
        let newPackage = StudyPackage(name: "Matematika", icon: "function")
        modelContext.insert(newPackage)
        
        let newPackage2 = StudyPackage(name: "Angličtina", icon: "globe")
        modelContext.insert(newPackage2)
    }
}
