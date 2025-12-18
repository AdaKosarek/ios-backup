//
//  FlashCardView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

struct FlashCardView: View {
    let question: String
    let answer: String
    let isFlipped: Bool // Řídí rodič (SessionView)
    
    var body: some View {
        ZStack {
            // ZADNÍ STRANA (Odpověď)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
                .overlay {
                    VStack {
                        Text("Odpověď")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        Text(answer)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Spacer()
                    }
                }
                .opacity(isFlipped ? 1 : 0) // Viditelná jen když je otočeno
                .rotation3DEffect(
                    .degrees(180), // Text na zadní straně musíme otočit, aby nebyl zrcadlově
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            
            // PŘEDNÍ STRANA (Otázka)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.gradient) // Barva z Figmy
                .shadow(radius: 5)
                .overlay {
                    VStack {
                        Text("Otázka")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        Text(question)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text("Klepni pro otočení")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.6))
                            .padding(.bottom, 20)
                        
                        Spacer()
                    }
                }
                .opacity(isFlipped ? 0 : 1) // Skryje se, když je otočeno
        }
        // Samotná 3D rotace celé karty
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        // Animace
        .animation(.spring(duration: 0.6, bounce: 0.2), value: isFlipped)
    }
}

#Preview {
    FlashCardView(question: "Co je Swift?", answer: "Programovací jazyk od Apple.", isFlipped: false)
        .padding()
        .frame(height: 400)
}
