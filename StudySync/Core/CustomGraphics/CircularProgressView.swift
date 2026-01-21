import SwiftUI

struct GlowingProgressView: View {
    var progress: Double // Hodnota 0.0 až 1.0
    
    var body: some View {
        ZStack {
            // 1. Pozadí (šedý kruh)
            Circle()
                .stroke(lineWidth: 15)
                .opacity(0.1)
                .foregroundColor(.secondary)
            
            // 2. Hlavní kruh (Gradient)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .foregroundStyle(
                    AngularGradient(gradient: Gradient(colors: [.blue, .purple, .blue]), center: .center)
                )
                .rotationEffect(Angle(degrees: 270.0)) // Začátek nahoře
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progress)
            
            // 3. Záře (Shadow)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .foregroundColor(.purple)
                .rotationEffect(Angle(degrees: 270.0))
                .blur(radius: 8) // Rozmazání vytvoří "neon" efekt
                .opacity(0.5)
            
            // 4. Text uprostřed
            VStack {
                Text("\(Int(progress * 100))%")
                    .font(.largeTitle)
                    .bold()
                    .contentTransition(.numericText()) // Pěkná animace čísel
                Text("Hotovo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    GlowingProgressView(progress: 0.65)
        .frame(width: 200, height: 200)
        .preferredColorScheme(.dark) // Vynikne ve tmě
}
