//
//  WatchLibraryView.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI
import SwiftData

struct DecksLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \StudyPackage.dateCreated) private var packages: [StudyPackage]
    
    let bgDark = Color(red: 0.05, green: 0.07, blue: 0.12)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Study cards")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .padding(.top)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "book.fill")
                                Text("StudySync")
                            }
                            .font(.headline)
                            
                            Text("12 day streak")
                                .font(.caption)
                                .opacity(0.7)
                        }
                        Spacer()
                        Text("90 XP")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                    .padding()
                    .background(Color(red: 0.12, green: 0.15, blue: 0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                    
                    HStack(spacing: 15) {
                        // Correct
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Correct")
                                }
                                .font(.caption)
                                .foregroundStyle(.green)
                                
                                Text("18")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.green.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // Incorrect
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("Incorrect")
                                }
                                .font(.caption)
                                .foregroundStyle(.red)
                                
                                Text("12")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.red.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Active Decks")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.leading)
                        
                        if packages.isEmpty {
                            DeckRow(name: "Matematika", isActive: true)
                            DeckRow(name: "Angličtina", isActive: true)
                            DeckRow(name: "Biologie", isActive: false)
                            DeckRow(name: "Historie", isActive: false)
                        } else {
                            ForEach(packages) { package in
                                DeckRowData(package: package)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 50)
                }
            }
        }
    }
}

struct DeckRow: View {
    let name: String
    @State var isActive: Bool
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.medium)
                .foregroundStyle(isActive ? .white : .gray)
            Spacer()
            Image(systemName: isActive ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isActive ? .blue : .gray)
                .font(.title3)
        }
        .padding()
        .background(
            isActive ?
            LinearGradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
            : LinearGradient(colors: [Color.white.opacity(0.05), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isActive ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            withAnimation {
                isActive.toggle()
            }
        }
    }
}

struct DeckRowData: View {
    let package: StudyPackage
    @State private var isSelected: Bool = true
    
    var body: some View {
        HStack {
            Text(package.name)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? .white : .gray)
            Spacer()
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? .blue : .gray)
                .font(.title3)
        }
        .padding()
        .background(
            isSelected ?
            LinearGradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
            : LinearGradient(colors: [Color.white.opacity(0.05), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            withAnimation {
                isSelected.toggle()
            }
        }
    }
}
