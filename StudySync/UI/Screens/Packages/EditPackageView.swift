//
//  EditPackageView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI
import SwiftData

struct EditPackageView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Stavy formuláře
    @State private var name: String = ""
    @State private var selectedColorHex: String = "blue" // Výchozí barva
    
    // Nabídka barev
    let availableColors = ["blue", "red", "green", "orange", "purple", "pink", "yellow", "gray"]
    
    var body: some View {
        NavigationStack {
            Form {
                // Sekce 1: Název
                Section("Název balíčku") {
                    TextField("Např. Matematika", text: $name)
                        .accessibilityIdentifier("packageNameField") // PŘIDÁNO PRO TESTY
                }
                
                // Sekce 2: Výběr barvy
                Section("Barva") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 10) {
                        ForEach(availableColors, id: \.self) { colorName in
                            Circle()
                                .fill(mapColor(colorName))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    if selectedColorHex == colorName {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                }
                                .onTapGesture {
                                    selectedColorHex = colorName
                                }
                                // PŘIDÁNO PRO TESTY: Dynamické ID pro každou barvu
                                .accessibilityIdentifier("color_\(colorName)")
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Nový balíček")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Vytvořit") {
                        savePackage()
                    }
                    .disabled(name.isEmpty)
                    .accessibilityIdentifier("createPackageButton") // PŘIDÁNO PRO TESTY
                }
            }
        }
    }
    
    // Funkce pro uložení
    private func savePackage() {
        let newPackage = StudyPackage(
            name: name,
            colorHex: selectedColorHex,
            icon: "book.closed.fill"
        )
        modelContext.insert(newPackage)
        dismiss()
    }
    
    // Pomocná funkce pro převod
    private func mapColor(_ name: String) -> Color {
        switch name {
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "yellow": return .yellow
        case "gray": return .gray
        default: return .blue
        }
    }
}

#Preview {
    EditPackageView()
}
