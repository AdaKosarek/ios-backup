//
//  SettingsView.swift
//  StudySync
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: AppLanguage = .czech
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. VRSTVA: Animace pozadí
                BackgroundBlob()
                    .ignoresSafeArea()
                
                // 2. VRSTVA: Obsah
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - Hlavička (Nová 3D ikona)
                        VStack(spacing: 16) {
                            // Použijeme naši novou ikonu "Settings" (Posuvníky)
                            PremiumPathIcon(type: .settings, color: selectedTheme.mainColor, size: 80)
                            
                            VStack(spacing: 4) {
                                Text("Nastavení")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                
                                Text("Přizpůsobte si aplikaci podle sebe")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.top, 20)
                        
                        // MARK: - Sekce Vzhled
                        VStack(alignment: .leading, spacing: 12) {
                            SectionLabel(title: "app_appearance")


                            
                            // Karta vzhledu
                            VStack(spacing: 0) {
                                // Výběr barvy
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Text("Akcentní barva")
                                            .font(.body)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text(selectedTheme.rawValue.capitalized)
                                            .foregroundStyle(selectedTheme.mainColor)
                                            .fontWeight(.bold)
                                    }
                                    
                                    // Kuličky pro výběr
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(AppTheme.allCases) { theme in
                                                ThemeCircle(theme: theme, isSelected: selectedTheme == theme)
                                                    .onTapGesture {
                                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                                            selectedTheme = theme
                                                        }
                                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                                        generator.impactOccurred()
                                                    }
                                            }
                                        }
                                        .padding(.vertical, 4) // Místo pro stíny
                                    }
                                }
                                .padding(20)
                            }
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)

                        // MARK: - Sekce Obecné
                        VStack(alignment: .leading, spacing: 12) {
                            SectionLabel(title: "basic")
                            
                            VStack(spacing: 0) {
                                // Jazyk
                                SettingsRowView(
                                    iconType: .doc, // Jako symbol textu/jazyka
                                    color: .blue,
                                    title: "Jazyk"
                                ) {
                                    Picker("", selection: $selectedLanguage) {
                                        ForEach(AppLanguage.allCases) { language in
                                            Text(language.rawValue.capitalized).tag(language)
                                        }
                                    }
                                    .tint(.secondary)
                                    .labelsHidden()
                                }
                                
                                Divider().padding(.leading, 60)
                                
                                // Notifikace
                                SettingsRowView(
                                    iconType: .bolt, // Jako symbol akce/notifikace
                                    color: .orange,
                                    title: "notification"
                                ) {
                                    Text("on")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                }
                            }
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Sekce O Aplikaci
                        VStack(alignment: .leading, spacing: 12) {
                            SectionLabel(title: "aboutApp")
                            
                            VStack(spacing: 0) {
                                SettingsRowView(
                                    iconType: .home,
                                    color: .purple,
                                    title: "version"
                                ) {
                                    Text("1.0.0 (Beta)")
                                        .foregroundStyle(.secondary)
                                        .font(.footnote)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.secondary.opacity(0.1))
                                        .clipShape(Capsule())
                                }
                            }
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("settings_title")
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Pomocné Komponenty

struct SectionLabel: View {
    let title: LocalizedStringKey
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.secondary)
            .padding(.leading, 10)
    }
}

// Univerzální řádek nastavení s Premium ikonou
struct SettingsRowView<Content: View>: View {
    let iconType: CustomIconType
    let color: Color
    let title: LocalizedStringKey
    let trailingContent: () -> Content
    
    var body: some View {
        HStack(spacing: 16) {
            // Zmenšená verze naší 3D ikony
            PremiumPathIcon(type: iconType, color: color, size: 40)
            
            Text(title)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            trailingContent()
        }
        .padding(16)
    }
}

struct ThemeCircle: View {
    let theme: AppTheme
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(theme.mainColor.gradient)
                .frame(width: 48, height: 48)
                .shadow(color: theme.mainColor.opacity(0.4), radius: 4, x: 0, y: 4)
            
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .overlay(
            Circle()
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}
