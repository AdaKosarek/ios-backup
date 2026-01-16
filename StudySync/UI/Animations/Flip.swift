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
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            // Zadní strana (Odpověď) - BÍLÁ
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white) // Bílá pro odpověď
                .shadow(radius: 5)
                .overlay(
                    Text(answer)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundStyle(.black) // Černý text na bílém
                )
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : 180), // Pokud je otočená, vidíme ji (0°), jinak je schovaná (180°)
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .opacity(isFlipped ? 1 : 0) // Skryjeme ji, když není aktivní (pro lepší efekt)
            
            // Přední strana (Otázka) - MODRÁ
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.gradient) // Modrá (s gradientem pro hezčí efekt) pro otázku
                .shadow(radius: 5)
                .overlay(
                    Text(question)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundStyle(.white) // Bílý text na modrém
                )
                .rotation3DEffect(
                    .degrees(isFlipped ? -180 : 0), // Pokud je otočená, schováme ji (-180°), jinak ji vidíme (0°)
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .opacity(isFlipped ? 0 : 1) // Skryjeme ji, když je otočeno
        }
        .frame(height: 300) // Výška karty
        .padding()
        .onTapGesture {
            onTap()
        }
    }
}
