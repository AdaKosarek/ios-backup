//
//  DropShape.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import SwiftUI

struct DropShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let top = CGPoint(x: rect.midX, y: rect.minY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)

        path.move(to: top)

        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )

        path.addQuadCurve(
            to: bottom,
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )

        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )

        path.addQuadCurve(
            to: top,
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )

        path.closeSubpath()
        return path
    }
}

