//
//  SliderShape.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//
import SwiftUI

struct SliderShape: Shape {
    let segments: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let segmentWidth = rect.width / CGFloat(segments)

        for i in 0..<segments {
            let x = CGFloat(i) * segmentWidth
            path.addRect(
                CGRect(
                    x: x,
                    y: 0,
                    width: segmentWidth - 2,
                    height: rect.height
                )
            )
        }
        return path
    }
}
