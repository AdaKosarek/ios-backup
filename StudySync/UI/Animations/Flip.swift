//
//  Flip.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//
import SwiftUI

struct FlipCardView: View {
    let question: String
    let answer: String
    let isFlipped: Bool
    let onTap: () -> Void // Callback po kliknutí
    
    var body: some View {
        ZStack {
            // Pozadí karty
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            // Obsah (Otázka nebo Odpověď)
            VStack {
                Text(isFlipped ? answer : question)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                    // DŮLEŽITÉ: Pokud je karta otočená, musíme text otočit zpět,
                    // jinak by byl zrcadlově obrácený (nečitelný).
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
            }
        }
        .frame(height: 350) // Výška karty
        .padding()
        // DŮLEŽITÉ: 3D Rotace celé karty
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        // Reakce na kliknutí
        .onTapGesture {
            onTap()
        }
        // Definice animace (pružinový efekt)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isFlipped)
    }
}

#Preview {
    FlipCardView(question: "Otázka", answer: "Odpověď", isFlipped: false, onTap: {})
}
