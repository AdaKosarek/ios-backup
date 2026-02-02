//
//  CategoryModel.swift
//  FinanceManager
//
//  Created by mp on 14.06.2025.
//

import SwiftUI

struct CategoryModel: Identifiable {
    var id: UUID
    var title: String
    var icon: String
    var color: Color
    
    static let other = CategoryModel(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        title: "Other",
        icon: "questionmark.circle",
        color: .gray
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: //RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    func toHex() -> String? {
        UIColor(self).toHex
    }
}

extension UIColor {
    var toHex: String? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
