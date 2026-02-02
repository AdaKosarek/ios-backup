//
//  Color+Design.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

extension Color {
    init(hex: String) {
        switch hex.lowercased() {
        case "red": self = .red
        case "green": self = .green
        case "orange": self = .orange
        case "purple": self = .purple
        case "pink": self = .pink
        case "yellow": self = .yellow
        case "gray": self = .gray
        case "blue": self = .blue
        default: self = .blue
        }
    }
}
// 1. Definice barev
enum AppTheme: String, CaseIterable, Identifiable {
    case blue = "Blue"
    case green = "Green"
    case orange = "Orange"
    case purple = "Purple"
    case red = "Red"
    
    var id: String { rawValue }
    
    var mainColor: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .orange: return .orange
        case .purple: return .purple
        case .red: return .red
        }
    }
    
    var localizedName: String {
        switch self {
        case .blue: return "Modrá"
        case .green: return "Zelená"
        case .orange: return "Oranžová"
        case .purple: return "Fialová"
        case .red: return "Červená"
        }
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case czech = "cs"
    case english = "en"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .czech: return "Čeština 🇨🇿"
        case .english: return "English 🇺🇸"
        }
    }
}
