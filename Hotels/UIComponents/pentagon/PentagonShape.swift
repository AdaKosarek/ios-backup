//
//  PentagonShape.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//
import SwiftUI

struct PentagonShape: Shape {

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        var path = Path()

        for i in 0..<5 {
            let angle = Double(i) * (2 * .pi / 5) - .pi / 2
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )

            i == 0 ? path.move(to: point) : path.addLine(to: point)
        }

        path.closeSubpath()
        return path
    }
}
