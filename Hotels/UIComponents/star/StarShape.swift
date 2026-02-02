//
//  StarShape.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import SwiftUI

// MARK: - Single Star Shape
struct StarShape: Shape {

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2

        let points = 5
        let angle = .pi / Double(points)

        var path = Path()

        for i in 0..<(points * 2) {
            let r = i.isMultiple(of: 2) ? radius : radius * 0.45
            let a = Double(i) * angle - .pi / 2

            let point = CGPoint(
                x: center.x + CGFloat(cos(a)) * r,
                y: center.y + CGFloat(sin(a)) * r
            )

            i == 0 ? path.move(to: point) : path.addLine(to: point)
        }

        path.closeSubpath()
        return path
    }
}
