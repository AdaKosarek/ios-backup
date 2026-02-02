//
//  CustomTabBar.swift
//  StudySync
//
//  Created by Martin Reich on 21.01.2026.
//



import SwiftUI

enum Tab: String, CaseIterable {
    case home
    case packages
    case stats
    case settings

    var iconType: CustomIconType {
        switch self {
        case .home: return .home
        case .packages: return .folder
        case .stats: return .chart
        case .settings: return .doc
        }
    }
    var titleKey: LocalizedStringKey {
            switch self {
            case .home: return "tab_home"
            case .packages: return "tab_packages"
            case .stats: return "tab_stats"
            case .settings: return "tab_settings"
            }
        }
}

extension Tab {
    var nameForUITest: String {
        switch self {
        case .home: return "home"
        case .packages: return "packages"
        case .stats: return "stats"
        case .settings: return "settings"
        }
    }
}



struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var activeColor: Color = .blue
    
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
                        ZStack {
                            if selectedTab == tab {
                                IconShapeWrapper(type: tab.iconType)
                                    .fill(activeColor.opacity(0.2))
                                    .frame(width: 38, height: 38)
                                    .blur(radius: 8)
                                    .matchedGeometryEffect(id: "bg", in: animationNamespace)
                            }
                            

                            IconShapeWrapper(type: tab.iconType)
                                .fill(selectedTab == tab ? activeColor.gradient : Color.gray.opacity(0.4).gradient)
                                .frame(width: 24, height: 24)
                                .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                                .offset(y: selectedTab == tab ? -2 : 0)
                        }
                        .frame(height: 30)
                        
                        Text(tab.titleKey)
                            .font(.system(size: 10, weight: selectedTab == tab ? .bold : .regular))
                            .foregroundStyle(
                                selectedTab == tab
                                ? activeColor
                                : Color.gray.opacity(0.6)
                            )
                            .opacity(selectedTab == tab ? 1.0 : 0.85)
                            .animation(.easeInOut(duration: 0.2), value: selectedTab)

                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }.accessibilityIdentifier("tab_\(tab.nameForUITest)")
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background {
            ZStack {
                Capsule()
                    .fill(.ultraThinMaterial)
            
                Capsule()
                    .fill(Color(UIColor.systemBackground).opacity(0.5))
            }
            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
        }
        .overlay(
            Capsule()
                .strokeBorder(.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 10)
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
