//
//  WatchSettingsScreenView.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//
/*
import SwiftUI

struct WatchSettingsView: View {
    @State private var connector = WatchConnector.shared
    @State private var notificationsEnabled = true
    
    var isSynced: Bool { !connector.receivedPackages.isEmpty }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Nastavení")
                    .font(.headline)
                
                // 1. Karta Synchronizace (Interaktivní)
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: isSynced ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                .foregroundStyle(isSynced ? .green : .orange)
                            
                            Text(isSynced ? "Synchronizováno" : "Bez dat")
                                .fontWeight(.bold)
                                .font(.caption)
                        }
                        Text(isSynced ? "\(connector.receivedPackages.count) balíčků připraveno" : "Čekám na iPhone...")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(isSynced ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Tlačítko Smazat data (Pro testování Empty State)
                Button(action: {
                    withAnimation {
                        // Vymaže data, aby sis mohl znovu zkusit "Nahrát Demo Data"
                        connector.receivedPackages.removeAll()
                    }
                }) {
                    Label("Smazat data (Reset)", systemImage: "trash")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.red.opacity(0.2))
                        .foregroundStyle(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                
                Divider().background(Color.white.opacity(0.2))
                
                // 2. Notifikace
                Toggle(isOn: $notificationsEnabled) {
                    VStack(alignment: .leading) {
                        Text("Notifikace")
                            .fontWeight(.medium)
                            .font(.caption)
                        Text("Denní připomenutí")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(.brandPurple)
                
                Text("Verze 1.0.1")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.top)
            }
            .padding()
        }
    }
}
*/
