//
//  TriangleShape.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//
import SwiftUI

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/*
 TriangleShape()
     .fill(Color.blue)
     .frame(width: 20, height: 20)
     .rotationEffect(.degrees(180))
 */
