//
//  TiltEffect.swift
//  StudySync
//
//  Created by Martin Reich on 21.01.2026.
//

import SwiftUI

// Jednoduchý modifikátor pro 3D náklon a odlesk
struct Simple3DModifier: ViewModifier {
    @State private var offset: CGSize = .zero
    @State private var isTouching = false
    
    func body(content: Content) -> some View {
        content
            // 1. Odlesk (Světelný pruh)
            .overlay(
                GeometryReader { proxy in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: proxy.size.width * 2, height: proxy.size.height * 2)
                    .offset(x: isTouching ? 200 : -200, y: isTouching ? 200 : -200)
                    .blur(radius: 5)
                    .opacity(isTouching ? 1 : 0)
                }
                .mask(Rectangle()) // Ořízne odlesk podle tvaru karty
            )
            // 2. Samotná 3D rotace
            .rotation3DEffect(
                .degrees(Double(offset.height / 10)), // Náklon nahoru/dolů (invertovaný pro přirozenost)
                axis: (x: 1, y: 0, z: 0)
            )
            .rotation3DEffect(
                .degrees(Double(-offset.width / 10)), // Náklon do stran
                axis: (x: 0, y: 1, z: 0)
            )
            .scaleEffect(isTouching ? 0.96 : 1.0) // Jemné zmenšení
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: offset)
            .animation(.easeInOut(duration: 0.3), value: isTouching)
            
            // 3. Gesto (Simultaneous = dovolí scrollovat)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isTouching = true
                        
                        // Omezení náklonu, aby se karta neotočila moc
                        let limit: CGFloat = 30
                        offset = CGSize(
                            width: min(max(value.translation.width, -limit), limit),
                            height: min(max(value.translation.height, -limit), limit)
                        )
                    }
                    .onEnded { _ in
                        // Návrat do původní polohy
                        isTouching = false
                        offset = .zero
                    }
            )
    }
}

// Rozšíření, abyste mohli psát jen .simple3D()
extension View {
    func simple3D() -> some View {
        self.modifier(Simple3DModifier())
    }
}
