//
//  RingShape.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import SwiftUI
struct RingShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addEllipse(in: rect)

        let innerRect = rect.insetBy(
            dx: rect.width * 0.25,
            dy: rect.height * 0.25
        )

        path.addEllipse(in: innerRect)

        return path
    }
}

/*
 RingShape()
     .fill(Color.blue, style: FillStyle(eoFill: true))
     .frame(width: 30, height: 30)
 
 HStack(spacing: 12) {
     DropShape().fill(.blue)
     HeartShape().fill(.red)
     HexagonShape().fill(.green)
     PentagonShape().fill(.orange)
     RingShape().fill(.purple, style: FillStyle(eoFill: true))
 }
 .frame(height: 30)
 */
