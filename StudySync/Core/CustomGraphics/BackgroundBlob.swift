//
//  Untitled.swift
//  StudySync
//
//  Created by Martin Reich on 21.01.2026.
//

import SwiftUI

struct BackgroundBlob: View {
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .blue
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // První "bublina" (Hlavní barva)
            Circle()
                .fill(selectedTheme.mainColor.gradient)
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .opacity(0.4)
                .offset(x: animate ? -100 : 100, y: animate ? -50 : 50)
                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animate)
            
            // Druhá "bublina"
            Circle()
                .fill(selectedTheme.mainColor.gradient)
                .frame(width: 250, height: 250)
                .blur(radius: 60)
                .opacity(0.3)
                .hueRotation(.degrees(30))
                .offset(x: animate ? 100 : -100, y: animate ? 100 : -100)
                .animation(.easeInOut(duration: 7).repeatForever(autoreverses: true), value: animate)
        }
        .animation(.spring, value: selectedTheme)
        .onAppear {
            animate.toggle()
        }
    }
}

#Preview {
    BackgroundBlob()
}
