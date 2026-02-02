//
//  RatingView.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//
import SwiftUI

struct RatingView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
    
            StarShape()
                .fill(Color.yellow)
                .frame(width: 22, height: 22)
        }
        .frame(width: 32, height: 32)
    }
}
