//
//  ButtonSyle.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import SwiftUI

struct BottomPrimaryButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 36)
            .background(
                Capsule()
                    .fill(Color(red: 0.36, green: 0.76, blue: 0.95)) // světle modrá
            )
            .shadow(
                color: .black.opacity(0.25),
                radius: 3,
                x: 0,
                y: 2
            )
            .opacity(isEnabled ? 1 : 0.3)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

extension ButtonStyle where Self == BottomPrimaryButtonStyle {
    static var bottomPrimary: BottomPrimaryButtonStyle {
        BottomPrimaryButtonStyle()
    }
}
