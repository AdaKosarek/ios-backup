import SwiftUI

struct WatchContentView: View {
    @State private var selection = 1 // Výchozí je Dashboard
    
    var body: some View {
        TabView(selection: $selection) {
            WatchStatsView()
                .tag(0)
            
            WatchDashboardView()
                .tag(1)
            
            WatchSettingsView()
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .background(Color.brandDarkBg.ignoresSafeArea()) // Tmavé pozadí pro celou appku
    }
}
