//
//  SquareShape.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//
import SwiftUI

struct SquareShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path(
            roundedRect: rect,
            cornerRadius: rect.height / 2
        )
    }
}

