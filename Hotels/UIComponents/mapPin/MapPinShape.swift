//
//  MapPinShape.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//
import SwiftUI

struct MapPinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addEllipse(in: CGRect(x: 0, y: 0,
                                   width: rect.width,
                                   height: rect.width))

        path.move(to: CGPoint(x: rect.midX, y: rect.width))
        path.addLine(to: CGPoint(x: rect.maxX * 0.75, y: rect.height))
        path.addLine(to: CGPoint(x: rect.minX * 0.25, y: rect.height))
        path.closeSubpath()

        return path
    }
}
