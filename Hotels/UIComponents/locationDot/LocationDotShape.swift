//
//  LocationDotShape.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//
import SwiftUI

struct LocationDotShapet: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.4), lineWidth: 8)
            Circle()
                .fill(Color.blue)
        }
        .frame(width: 20, height: 20)
    }
}
