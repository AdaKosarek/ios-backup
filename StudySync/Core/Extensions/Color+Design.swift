//
//  Color+Design.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

extension Color {
    // Inicializátor, který mapuje stringové názvy barev z modelu na SwiftUI Color objekty
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
