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
    
    // Stavy pro efekty
    @State private var flashOpacity: Double = 0.0
    
    // Stavy pro Ripple (otisk) a Tilt (náklon)
    @State private var tapLocation: CGPoint = .zero
    @State private var startRippleAnimation = false
    @State private var rippleId = UUID()
    
    // Stavy pro pohyb
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    var body: some View {
        ZStack {
            // --- ZADNÍ STRANA (ODPOVĚĎ) ---
            CardFace(text: answer, backgroundColor: .white, textColor: .black)
                .overlay(
                    RippleOverlay(location: tapLocation, trigger: startRippleAnimation)
                        .id(rippleId)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                )
                .overlay(FlashOverlay(opacity: flashOpacity))
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : 180),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .opacity(isFlipped ? 1 : 0)
                .accessibility(hidden: !isFlipped)
            
            // --- PŘEDNÍ STRANA (OTÁZKA) ---
            CardFace(text: question, backgroundColor: .blue, textColor: .white, useGradient: true)
                .overlay(
                    RippleOverlay(location: tapLocation, trigger: startRippleAnimation)
                        .id(rippleId)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                )
                .overlay(FlashOverlay(opacity: flashOpacity))
                .rotation3DEffect(
                    .degrees(isFlipped ? -180 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .opacity(isFlipped ? 0 : 1)
                .accessibility(hidden: isFlipped)
        }
        .frame(height: 300)
        .padding()
        
        // --- ANIMACE ZMĚNY VELIKOSTI ---
        .scaleEffect(isFlipped ? 1.0 : 1.0)
        .phaseAnimator([false, true], trigger: isFlipped) { content, phase in
            content
                .scaleEffect(phase ? 1.0 : 0.95)
        } animation: { phase in
            .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)
        }

        // --- 3D NÁKLON KARTY ---
        .rotation3DEffect(
            .degrees(isDragging ? Double(-dragOffset.height / 10) : 0),
            axis: (x: 1, y: 0, z: 0)
        )
        .rotation3DEffect(
            .degrees(isDragging ? Double(dragOffset.width / 10) : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .scaleEffect(isDragging ? 0.97 : 1.0)

        // --- HLAVNÍ GESTO (Sjednocené pro klik i tah) ---
        // Používáme DragGesture s minimální vzdáleností 0, což chytí i kliknutí
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // Pokud teprve začínáme gesto, uložíme pozici pro Ripple efekt
                    if !isDragging {
                        tapLocation = value.startLocation
                        isDragging = true
                    }
                    
                    // Výpočet náklonu (Tilt)
                    withAnimation(.interactiveSpring) {
                        let limit: CGFloat = 100
                        dragOffset = CGSize(
                            width: min(max(value.translation.width, -limit), limit),
                            height: min(max(value.translation.height, -limit), limit)
                        )
                    }
                }
                .onEnded { value in
                    // Návrat karty do roviny
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        isDragging = false
                        dragOffset = .zero
                    }
                    
                    // DETEKCE KLIKNUTÍ vs. POSUNU
                    // Pokud se prst pohnul jen málo (méně než 10 bodů), je to kliknutí
                    if abs(value.translation.width) < 10 && abs(value.translation.height) < 10 {
                        // Spustíme efekty
                        triggerRipple()
                        triggerFlashAndHaptic()
                        // Otočíme kartu
                        onTap()
                    }
                }
        )
    }
    
    // Spuštění Ripple (vlnky)
    private func triggerRipple() {
        rippleId = UUID()
        // Malé zpoždění zajistí restart animace
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            withAnimation(.easeOut(duration: 0.5)) {
                startRippleAnimation = true
            }
        }
    }
    
    // Spuštění Záblesku a Haptiky
    private func triggerFlashAndHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        withAnimation(.easeOut(duration: 0.2)) {
            flashOpacity = 0.3
        }
        withAnimation(.easeIn(duration: 0.3).delay(0.1)) {
            flashOpacity = 0.0
        }
    }
}

// MARK: - Pomocné komponenty (beze změny)

struct RippleOverlay: View {
    let location: CGPoint
    let trigger: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 50, height: 50)
                .position(location)
                .scaleEffect(trigger ? 8 : 0.1) // Zvětšení vlnky
                .opacity(trigger ? 0 : 1)       // Zmizení
        }
        .allowsHitTesting(false)
    }
}

struct CardFace: View {
    let text: String
    let backgroundColor: Color
    let textColor: Color
    var useGradient: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(useGradient ? backgroundColor.gradient : backgroundColor.gradient)
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
            .overlay(
                Text(text)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundStyle(textColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct FlashOverlay: View {
    var opacity: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white)
            .opacity(opacity)
            .blendMode(.plusLighter)
            .allowsHitTesting(false)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        FlipCardView(
            question: "Klikni na mě!",
            answer: "Vidíš tu vlnku?",
            isFlipped: false,
            onTap: {}
        )
    }
}
