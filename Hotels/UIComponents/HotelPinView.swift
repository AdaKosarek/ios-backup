//
//  HotelPinView.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import SwiftUI

struct HotelPinView: View {

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.brown)
                .frame(width: 36, height: 36)

            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
        }
        .shadow(
            color: .black.opacity(0.25),
            radius: 4,
            x: 0,
            y: 2
        )
    }
}
