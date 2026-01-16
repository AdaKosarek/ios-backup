//
//  SettingsView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//


import SwiftUI

struct SettingsView: View {
    // Toto automaticky ukládá volbu do paměti telefonu
    @AppStorage("selectedLanguage") private var selectedLanguage: AppLanguage = .czech
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
    
    var body: some View {
        NavigationStack {
            Form {
                // Sekce: Jazyk
                Section(header: Text("Jazyk aplikace")) {
                    Picker("Vyberte jazyk", selection: $selectedLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .pickerStyle(.inline) // Nebo .menu, podle vkusu
                }
                
                // Sekce: Vzhled (Barvy)
                Section(header: Text("Vzhled aplikace")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(AppTheme.allCases) { theme in
                                Circle()
                                    .fill(theme.mainColor)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        // Kroužek okolo vybrané barvy
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedTheme == theme ? 3 : 0)
                                    )
                                    .onTapGesture {
                                        withAnimation {
                                            selectedTheme = theme
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    
                    // Textový popis vybrané barvy
                    HStack {
                        Text("Vybraná barva:")
                        Spacer()
                        Text(selectedTheme.localizedName)
                            .foregroundStyle(selectedTheme.mainColor)
                            .bold()
                    }
                }
                
                // Sekce: O aplikaci (Bonus)
                Section(header: Text("O aplikaci")) {
                    HStack {
                        Text("Verze")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Nastavení")
        }
    }
}

#Preview {
    SettingsView()
}
