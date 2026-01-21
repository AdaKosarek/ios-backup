//
//  Confeti.swift
//  StudySync
//
//  Created by Martin Reich on 12.01.2026.
//
//

import SwiftUI

struct ConfettiView: View {
    // Počet konfet
    let count: Int = 60
    
    // Barvy konfet
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan]
    
    // Stav pro spuštění animace
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<count, id: \.self) { index in
                    ConfettiPiece(
                        colors: colors,
                        geometry: geometry,
                        isAnimating: isAnimating,
                        index: index
                    )
                }
            }
            .onAppear {
                // Spustí animaci okamžitě po zobrazení
                // Malé zpoždění pomůže zajistit, že se view stihlo vykreslit před startem animace
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = true
                }
            }
        }
        // DŮLEŽITÉ: Zajistí, že přes konfety lze stále klikat na tlačítka pod nimi
        .allowsHitTesting(false)
    }
}

// Pomocné view pro jeden kus konfety
struct ConfettiPiece: View {
    let colors: [Color]
    let geometry: GeometryProxy
    var isAnimating: Bool
    let index: Int
    
    // Náhodné vlastnosti pro každý kus (vypočítané při vytvoření)
    let color: Color
    let startX: Double
    let endX: Double
    let rotationSpeed: Double
    let scale: Double
    let duration: Double
    let delay: Double
    
    init(colors: [Color], geometry: GeometryProxy, isAnimating: Bool, index: Int) {
        self.colors = colors
        self.geometry = geometry
        self.isAnimating = isAnimating
        self.index = index
        
        // Inicializace náhodných hodnot
        self.color = colors.randomElement() ?? .red
        self.startX = Double.random(in: 0...geometry.size.width)
        // Konfeta trochu "odvane" doleva nebo doprava
        self.endX = startX + Double.random(in: -150...150)
        // Různá rychlost a směr rotace
        self.rotationSpeed = Double.random(in: 360...1080) * (Bool.random() ? 1 : -1)
        self.scale = Double.random(in: 0.7...1.2)
        self.duration = Double.random(in: 3.5...6.0)
        // Některé konfety vyletí později
        self.delay = Double.random(in: 0.0...0.8)
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 12, height: 8) // Velikost konfety
            .scaleEffect(scale)
            // 2D rotace
            .rotationEffect(Angle(degrees: isAnimating ? rotationSpeed : 0))
            // 3D rotace pro lepší efekt "plachtění"
            .rotation3DEffect(
                Angle(degrees: isAnimating ? rotationSpeed : 0),
                axis: (x: Double.random(in: 0...1), y: Double.random(in: 0...1), z: 0)
            )
            // Pozice: startuje nad obrazovkou, končí pod obrazovkou
            .position(
                x: isAnimating ? endX : startX,
                y: isAnimating ? geometry.size.height + 100 : -100
            )
            // Aplikace animace na tento konkrétní kus
            .animation(
                Animation.linear(duration: duration)
                    .delay(delay),
                value: isAnimating
            )
    }
}

// Náhled pro SwiftUI Canvas
#Preview {
    ConfettiView()
        .background(Color.gray.opacity(0.2))
}
