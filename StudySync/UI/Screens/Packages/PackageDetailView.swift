//
//  PackageDetailView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

struct PackageDetailView: View {
    @Bindable var package: StudyPackage
    @Environment(\.modelContext) private var modelContext
    
    // --- OPRAVA 1: Tady chyběla tato proměnná ---
    @State private var showingStudySession = false
    
    @State private var showingAddGroupAlert = false
    @State private var newGroupName = ""
    
    var body: some View {
        List {
            // Sekce 1: Informace a Tlačítko Play
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Celkem skupin")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(package.groups.count)")
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                    
                    // Tlačítko pro spuštění učení
                    Button(action: {
                        // Spustíme jen pokud jsou nějaké karty
                        let hasCards = !package.groups.flatMap({ $0.cards }).isEmpty
                        if hasCards {
                            showingStudySession = true
                        }
                    }) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 40))
                            // --- OPRAVA 2: Teď už bude fungovat Color(hex:) díky rozšíření dole ---
                            .foregroundStyle(Color(hex: package.colorHex))
                    }
                    .buttonStyle(.plain) // Aby to nebralo kliknutí celého řádku
                }
                .padding(.vertical, 8)
            }
            
            // Sekce 2: Seznam skupin
            Section("Skupiny") {
                if package.groups.isEmpty {
                    Text("Zatím žádné skupiny. Klikni na +")
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(package.groups) { group in
                        NavigationLink(destination: CardListView(group: group)) {
                            HStack {
                                Text(group.name)
                                    .font(.headline)
                                Spacer()
                                Text("\(group.cards.count) karet")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                    .onDelete(perform: deleteGroup)
                }
            }
        }
        .navigationTitle(package.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddGroupAlert = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("Nová skupina", isPresented: $showingAddGroupAlert) {
            TextField("Název (např. Geometrie)", text: $newGroupName)
            Button("Zrušit", role: .cancel) { }
            Button("Vytvořit") {
                addGroup()
            }
        }
        // Tady se otevírá obrazovka učení
        .fullScreenCover(isPresented: $showingStudySession) {
            let allCards = package.groups.flatMap { $0.cards }
            NavigationStack {
                SessionView(cards: allCards)
            }
        }
    }
    
    private func addGroup() {
        guard !newGroupName.isEmpty else { return }
        let newGroup = StudyGroup(name: newGroupName)
        package.groups.append(newGroup)
        newGroupName = ""
    }
    
    private func deleteGroup(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let group = package.groups[index]
                modelContext.delete(group)
            }
        }
    }
}

// --- OPRAVA 2: Toto rozšíření (Extension) musí být na konci souboru ---
extension Color {
    init(hex: String) {
        switch hex {
        case "red": self = .red
        case "green": self = .green
        case "orange": self = .orange
        case "purple": self = .purple
        case "pink": self = .pink
        case "yellow": self = .yellow
        case "gray": self = .gray
        default: self = .blue
        }
    }
}
