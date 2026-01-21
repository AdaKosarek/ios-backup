//
//  CustomTabBar.swift
//  StudySync
//
//  Created by Martin Reich on 21.01.2026.
//



import SwiftUI

// Definice záložek
enum Tab: String, CaseIterable {
    case home = "Dnes"
    case packages = "Balíčky"
    case stats = "Statistiky"
    case settings = "Nastavení"
    
    // Přiřazení našich vlastních ikon
    var iconType: CustomIconType {
        switch self {
        case .home: return .home
        case .packages: return .folder
        case .stats: return .chart
        case .settings: return .doc // Nebo vytvořit tvar 'gear', prozatím doc
        }
    }
}



struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var activeColor: Color = .blue
    
    // Pro animaci pozadí
    @Namespace private var animationNamespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        selectedTab = tab
                    }
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                } label: {
                    VStack(spacing: 4) {
                        // IKONA
                        ZStack {
                            if selectedTab == tab {
                                // Záře pod vybranou ikonou
                                IconShapeWrapper(type: tab.iconType)
                                    .fill(activeColor.opacity(0.2))
                                    .frame(width: 38, height: 38) // Větší záře
                                    .blur(radius: 8)
                                    .matchedGeometryEffect(id: "bg", in: animationNamespace)
                            }
                            
                            // Samotná ikona
                            IconShapeWrapper(type: tab.iconType)
                                .fill(selectedTab == tab ? activeColor.gradient : Color.gray.opacity(0.4).gradient)
                                .frame(width: 24, height: 24)
                                .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                                .offset(y: selectedTab == tab ? -2 : 0) // Jemný posun nahoru při výběru
                        }
                        .frame(height: 30)
                        
                        // TEXT (Zobrazíme jen u vybraného nebo u všech, podle preference)
                        if selectedTab == tab {
                            Text(tab.rawValue)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(activeColor)
                                .transition(.opacity.combined(with: .scale))
                        } else {
                            // U nevybraných můžeme skrýt text, aby byl bar čistší,
                            // nebo ho nechat malý šedý. Zde ho necháme jako malou tečku nebo skrytý.
                             Circle()
                                 .fill(.gray.opacity(0.3))
                                 .frame(width: 4, height: 4)
                                 .padding(.top, 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
            }
        }
        .padding(.vertical, 14) // Vnitřní výška baru
        .padding(.horizontal, 8) // Vnitřní odsazení
        .background {
            // POZADÍ - PLOVOUCÍ KAPLE
            ZStack {
                // 1. Skleněný materiál
                Capsule() // Nebo RoundedRectangle(cornerRadius: 35)
                    .fill(.ultraThinMaterial)
                
                // 2. Bílý podklad (pro lepší kontrast)
                Capsule()
                    .fill(Color(UIColor.systemBackground).opacity(0.5))
            }
            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8) // Hluboký stín
        }
        // Rámeček
        .overlay(
            Capsule()
                .strokeBorder(.white.opacity(0.2), lineWidth: 1)
        )
        // ODSAZENÍ OD KRAJŮ (To, co jste chtěl)
        .padding(.horizontal, 24)
        .padding(.bottom, 10) // Zvednutí ode dna (nad Home Indicator)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.home), activeColor: .orange)
        }
    }
}
