//
//  SettingsView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//


import SwiftUI

struct SettingsView: View {
    // Ukládání do paměti
    // Předpokládám, že AppLanguage a AppTheme máte definované jinde v projektu
    @AppStorage("selectedLanguage") private var selectedLanguage: AppLanguage = .czech
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Pozadí celé obrazovky (jemně šedé)
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - Hlavička
                        VStack(spacing: 8) {
                            Image(systemName: "book.fill") // Zde by bylo logo aplikace
                                .font(.system(size: 60))
                                .foregroundStyle(selectedTheme.mainColor.gradient)
                                .shadow(color: selectedTheme.mainColor.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Text("StudySync")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Přizpůsobte si aplikaci podle sebe")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // MARK: - Sekce Vzhled (Barvy)
                        VStack(alignment: .leading, spacing: 15) {
                            SectionHeader(title: "VZHLED APLIKACE", icon: "paintbrush.fill")
                            
                            VStack(spacing: 0) {
                                // Náhled vybrané barvy
                                // Poznámka: Pokud vám 'localizedName' hází chybu, přepište to na .rawValue nebo jinou vlastnost, kterou máte v AppTheme
                                SettingsRow(icon: "paintpalette.fill", color: selectedTheme.mainColor, title: "Akcentní barva", value: selectedTheme.rawValue.capitalized)
                                
                                Divider().padding(.leading, 50)
                                
                                // Výběr barev (Bubliny)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(AppTheme.allCases) { theme in
                                            ThemeCircle(theme: theme, isSelected: selectedTheme == theme)
                                                .onTapGesture {
                                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                                        selectedTheme = theme
                                                    }
                                                }
                                        }
                                    }
                                    .padding(15)
                                }
                            }
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)

                        // MARK: - Sekce Jazyk a Nastavení
                        VStack(alignment: .leading, spacing: 15) {
                            SectionHeader(title: "OBECNÉ", icon: "gearshape.fill")
                            
                            VStack(spacing: 0) {
                                // Jazyk
                                HStack {
                                    Image(systemName: "globe")
                                        .foregroundStyle(.white)
                                        .frame(width: 30, height: 30)
                                        .background(Color.blue.gradient)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    Text("Jazyk")
                                        .font(.body)
                                    
                                    Spacer()
                                    
                                    Picker("", selection: $selectedLanguage) {
                                        ForEach(AppLanguage.allCases) { language in
                                            // Pokud 'displayName' neexistuje, použijte .rawValue
                                            Text(language.rawValue.capitalized).tag(language)
                                        }
                                    }
                                    .tint(.secondary)
                                    .labelsHidden()
                                }
                                .padding()
                                
                                Divider().padding(.leading, 50)
                                
                                // Notifikace (Příklad)
                                SettingsRow(icon: "bell.fill", color: .red, title: "Notifikace", value: "Zapnuto")
                            }
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Patička
                        VStack(spacing: 5) {
                            Text("StudySync v1.0.0")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            Text("Made with ❤️ by Miroslav")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Nastavení")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Pomocné Komponenty (Tyto pravděpodobně nemáte, takže je necháme)

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
        }
        .foregroundStyle(.secondary)
        .padding(.leading, 8)
    }
}

struct SettingsRow: View {
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

struct ThemeCircle: View {
    let theme: AppTheme
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            // Používáme theme.mainColor (ujistěte se, že to váš AppTheme enum má)
            Circle()
                .fill(theme.mainColor.gradient)
                .frame(width: 45, height: 45)
                .shadow(color: theme.mainColor.opacity(0.4), radius: 4, x: 0, y: 4)
            
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .overlay(
            Circle()
                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
        )
    }
}

// ZDE JSEM SMAZAL ENUMY AppLanguage A AppTheme, PROTOŽE UŽ JE MÁTE.
