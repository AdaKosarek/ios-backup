//
//  colorsExtension.swift
//  StudySync
//
//  Created by mp on 23.01.2026.
//

import SwiftUI

// MARK: - Barvy a Gradienty
extension Color {
    static let brandPurple = Color(red: 0.4, green: 0.2, blue: 0.8) // Příklad fialové
    static let brandBlue = Color(red: 0.2, green: 0.4, blue: 1.0) // Příklad modré
    static let brandDarkBg = Color(red: 0.1, green: 0.1, blue: 0.15) // Tmavé pozadí
    
    static let mainGradient = LinearGradient(
        colors: [brandBlue, brandPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}


extension View {
    func watchBackground() -> some View {
        self
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0/255, green: 0/255, blue: 8/255),
                        Color(red: 10/255, green: 20/255, blue: 45/255),
                        Color(red: 10/255, green: 20/255, blue: 45/255),
                        Color(red: 0/255, green: 0/255, blue: 8/255)
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
                .ignoresSafeArea()
            )
    }
}

