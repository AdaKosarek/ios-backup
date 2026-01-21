//
//  PremiumPathIcon.swift
//  StudySync
//
//  Created by Martin Reich on 21.01.2026.
//




import SwiftUI

struct IconShapeWrapper: Shape {
    let type: CustomIconType
    
    func path(in rect: CGRect) -> Path {
        switch type {
        case .home:     return HomeShape().path(in: rect) // Použije vylepšený domeček
        case .settings: return GearShape().path(in: rect) // Použije ozubené kolo
        case .folder: return FolderShape().path(in: rect)
        case .chart:    return ChartBarsShape().path(in: rect)
        case .flame:    return FlameShape().path(in: rect)
        case .bolt:     return BoltShape().path(in: rect)
        case .target:   return BullseyeShape().path(in: rect)
        case .star:     return StarShape().path(in: rect)
        case .layers:   return LayersShape().path(in: rect)
        case .doc:      return DocShape().path(in: rect)
        case .book:     return BookShape().path(in: rect)
        }
    }
}


//
//  PremiumPathIcon.swift
//  StudySync
//

import SwiftUI

struct PremiumPathIcon: View {
    let type: CustomIconType
    let color: Color
    var size: CGFloat = 50
    
    var body: some View {
        let shape = IconShapeWrapper(type: type)
        
        ZStack {
            // A. POZADÍ IKONY (Destička)
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(UIColor.secondarySystemGroupedBackground),
                            Color(UIColor.systemGroupedBackground)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.22)
                        .stroke(.white.opacity(0.5), lineWidth: 0.5)
                )

            // B. SAMOTNÝ TVAR (S 3D efekty)
            shape
                .fill(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: FillStyle(eoFill: true) // <--- DŮLEŽITÉ: Umožní díry v ikonách
                )
                .frame(width: size * 0.55, height: size * 0.55)
                // Vnitřní stín
                .overlay(
                    shape
                        .stroke(.black.opacity(0.1), lineWidth: 1)
                        .blur(radius: 0.5)
                        .offset(x: 1, y: 1)
                        .mask(
                            shape.fill(style: FillStyle(eoFill: true)) // I tady musí být eoFill
                        )
                )
                // Horní lesk
                .overlay(
                    shape
                        .fill(.white.opacity(0.3), style: FillStyle(eoFill: true))
                        .mask(
                            LinearGradient(colors: [.white, .clear], startPoint: .top, endPoint: .center)
                        )
                )
                .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 3)
            
            // C. ODLESK NA POZADÍ
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.15), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .mask(Circle().offset(x: -size * 0.2, y: -size * 0.2).blur(radius: 5))
        }
        .frame(width: size, height: size)
    }
}
