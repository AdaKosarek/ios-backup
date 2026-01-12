import SwiftUI
import SwiftData

struct PackageDetailView: View {
    @Bindable var package: StudyPackage
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingStudySession = false
    @State private var showingAddGroupAlert = false
    @State private var newGroupName = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Celkem skupin")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(package.groups.count)")
                            .font(.title2)
                            .bold()
                            .accessibilityIdentifier("groupCountText") // PŘIDÁNO
                    }
                    Spacer()
                    
                    Button(action: {
                        let hasCards = !package.groups.flatMap({ $0.cards }).isEmpty
                        if hasCards {
                            showingStudySession = true
                        }
                    }) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Color(hex: package.colorHex))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("playSessionButton") // PŘIDÁNO
                }
                .padding(.vertical, 8)
            }
            
            Section("Skupiny") {
                if package.groups.isEmpty {
                    Text("Zatím žádné skupiny. Klikni na +")
                        .foregroundStyle(.secondary)
                        .italic()
                        .accessibilityIdentifier("emptyGroupsText") // PŘIDÁNO
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
                        .accessibilityIdentifier("groupRow_\(group.name)") // PŘIDÁNO
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
                .accessibilityIdentifier("addGroupButton") // PŘIDÁNO
            }
        }
        .alert("Nová skupina", isPresented: $showingAddGroupAlert) {
            TextField("Název (např. Geometrie)", text: $newGroupName)
                .accessibilityIdentifier("newGroupNameField") // PŘIDÁNO
            Button("Zrušit", role: .cancel) { }
            Button("Vytvořit") {
                addGroup()
            }
            .accessibilityIdentifier("confirmAddGroupButton") // PŘIDÁNO
        }
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

// Extension ponechána beze změny...
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
