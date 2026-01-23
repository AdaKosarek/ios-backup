//
//  SplashScreenView.swift
//  StudySync
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isFinished: Bool
    
    @State private var startEntranceAnimation = false
    @State private var textOpacity = 0.0
    @State private var rotationAngle: Double = 0
    
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
    
    var body: some View {
        ZStack {
            // Pozadí
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    // Záře za ikonou
                    Circle()
                        .fill(selectedTheme.mainColor.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .scaleEffect(startEntranceAnimation ? 1.2 : 0.8)
                        .blur(radius: 20)
                    
                    // ZMĚNA: Ikona knihy, která se točí
                    PremiumPathIcon(type: .book, color: selectedTheme.mainColor, size: 100)
                        // Přílet (zvětšení)
                        .scaleEffect(startEntranceAnimation ? 1.0 : 0.5)
                        // Nekonečná rotace
                        .rotationEffect(.degrees(rotationAngle))
                }
                
                // NÁZEV APLIKACE
                VStack(spacing: 5) {
                    Text("StudySync")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text("Uč se chytřeji")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .tracking(2)
                }
                .opacity(textOpacity)
                .offset(y: startEntranceAnimation ? 0 : 20)
            }
        }
        .task {
            // 1. SPUŠTĚNÍ NEKONEČNÉ ROTACE (Oddělený Task)
            Task { @MainActor in
                // Lineární animace trvající 3 sekundy, opakuje se navždy
                withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
            
            // 2. SPUŠTĚNÍ PŘÍLETOVÉ ANIMACE (Škálování a text)
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                startEntranceAnimation = true
            }
            
            // Čekání na text
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
            withAnimation(.easeOut(duration: 0.8)) {
                textOpacity = 1.0
            }
            
            // 3. ČEKÁNÍ A PŘEPNUTÍ DO APLIKACE
            try? await Task.sleep(nanoseconds: 2_500_000_000) // 2.5s
            
            withAnimation(.easeOut(duration: 0.5)) {
                isFinished = false
            }
        }
    }
}

#Preview {
    SplashScreenView(isFinished: .constant(true))
}
