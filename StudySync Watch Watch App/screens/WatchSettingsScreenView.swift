//
//  WatchSettingsScreenView.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

//
//  SettingsScreenView.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//

import SwiftUI

struct SettingsScreenView: View {
    @State private var notificationsEnabled = true
    
    let bgDark = Color(red: 0.05, green: 0.07, blue: 0.12)
    let cardBg = Color(red: 0.1, green: 0.12, blue: 0.18)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Settings")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .padding(.top)
                    
                    // --- 1. SYNC STATUS (Zelený box) ---
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                Text("Synced")
                            }
                            .font(.headline)
                            .foregroundStyle(.green)
                            
                            Text("Last synced: just now")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // --- 2. FORCE SYNC BUTTON (Modrý) ---
                    Button(action: { /* Fake action */ }) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text("Force Sync")
                        }
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.blue.opacity(0.4), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    
                    // --- 3. NOTIFICATIONS (Toggle) ---
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Notifications")
                                .font(.headline)
                                .foregroundStyle(.white)
                            HStack {
                                Image(systemName: "bell.fill")
                                    .font(.caption)
                                Text("Daily reminders")
                                    .font(.caption)
                            }
                            .foregroundStyle(.gray)
                        }
                        Spacer()
                        
                        Toggle("", isOn: $notificationsEnabled)
                            .labelsHidden()
                            .tint(.green)
                    }
                    .padding()
                    .background(cardBg) // Tmavší šedá
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // --- 4. STUDY SETTINGS (Seznam) ---
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Study Settings")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.leading)
                        
                        // Položka 1
                        SettingRow(title: "Cards per session", value: "5")
                        
                        // Položka 2
                        SettingRow(title: "Session reminder", value: "2h")
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                    
                    // --- 5. RESET DATA (Červené tlačítko) ---
                    Button(action: { /* Fake action */ }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Reset Data")
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.red.opacity(0.4), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                    .padding(.horizontal)
                    
                    Text("Version 1.0.0")
                        .font(.caption2)
                        .foregroundStyle(.gray.opacity(0.5))
                        .padding(.bottom, 80)
                }
            }
        }
    }
}

// Pomocná komponenta pro řádek nastavení
struct SettingRow: View {
    let title: String
    let value: String
    let cardBg = Color(red: 0.1, green: 0.12, blue: 0.18)
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white)
            Spacer()
            Text(value)
                .foregroundStyle(.gray)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding()
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    SettingsScreenView()
}
