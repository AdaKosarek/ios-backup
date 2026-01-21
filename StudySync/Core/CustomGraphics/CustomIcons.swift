import SwiftUI

enum CustomIconType {
    // Navigace
    case home       // Domů
    case folder   // Balíčky (Složka)
    case chart      // Statistiky (Graf)
    case settings   // Nastavení (Ozubené kolo)
    
    // Statistiky a seznamy
    case flame      // Streak
    case bolt       // Energie
    case target     // Cíle
    case star       // Hodnocení
    case layers     // Skupiny
    case doc        // Kartičky
    case book
}



// --- 1. DOMEČEK (Vylepšený s komínem a dveřmi) ---
struct HomeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let roofH = h * 0.4

        // Tělo a střecha
        path.move(to: CGPoint(x: w * 0.15, y: h))
        path.addLine(to: CGPoint(x: w * 0.15, y: roofH))
        path.addLine(to: CGPoint(x: w * 0.5, y: 0))
        path.addLine(to: CGPoint(x: w * 0.85, y: roofH))
        path.addLine(to: CGPoint(x: w * 0.85, y: h))
        path.closeSubpath()

        // Komín
        path.addRect(CGRect(x: w * 0.68, y: h * 0.12, width: w * 0.1, height: h * 0.18))

        // Dveře
        path.addRoundedRect(in: CGRect(x: w*0.42, y: h*0.65, width: w*0.16, height: h*0.35), cornerSize: CGSize(width: 2, height: 2))

        return path
    }
}

// --- 2. OZUBENÉ KOLO (Settings) ---
struct GearShape: Shape {
    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2
        var path = Path()

        // Hlavní kruh
        path.addEllipse(in: CGRect(x: c.x - r*0.7, y: c.y - r*0.7, width: r*1.4, height: r*1.4))

        // Zuby
        for i in 0..<8 {
            let angle = Angle.degrees(Double(i) * 45.0)
            let toothW = r * 0.25
            let toothH = r * 0.35
            
            var tooth = Path(roundedRect: CGRect(x: c.x - toothW/2, y: c.y - r, width: toothW, height: toothH), cornerSize: CGSize(width: 2, height: 2))
            
            tooth = tooth.applying(CGAffineTransform(translationX: -c.x, y: -c.y))
                .applying(CGAffineTransform(rotationAngle: angle.radians))
                .applying(CGAffineTransform(translationX: c.x, y: c.y))
            path.addPath(tooth)
        }
        
        // Středový kruh (díra)
        path.addEllipse(in: CGRect(x: c.x - r*0.25, y: c.y - r*0.25, width: r*0.5, height: r*0.5))

        return path
    }
}

// --- 3. SLOŽKA (Packages) ---
struct FolderShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width; let h = rect.height
        path.addRoundedRect(in: CGRect(x: 0, y: h * 0.2, width: w, height: h * 0.8), cornerSize: CGSize(width: w*0.1, height: h*0.1))
        path.move(to: CGPoint(x: 0, y: h * 0.2))
        path.addLine(to: CGPoint(x: 0, y: h * 0.1))
        path.addQuadCurve(to: CGPoint(x: w * 0.1, y: 0), control: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: w * 0.4, y: 0))
        path.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.2), control: CGPoint(x: w * 0.5, y: 0))
        path.closeSubpath()
        return path
    }
}

// --- 4. GRAF (Stats) ---
struct ChartBarsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width; let h = rect.height; let bw = w*0.25
        path.addRoundedRect(in: CGRect(x: 0, y: h*0.6, width: bw, height: h*0.4), cornerSize: CGSize(width: 2, height: 2))
        path.addRoundedRect(in: CGRect(x: w*0.375, y: h*0.3, width: bw, height: h*0.7), cornerSize: CGSize(width: 2, height: 2))
        path.addRoundedRect(in: CGRect(x: w*0.75, y: 0, width: bw, height: h), cornerSize: CGSize(width: 2, height: 2))
        return path
    }
}

// --- 5. OHEŇ (Streak) ---
struct FlameShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width; let h = rect.height
        path.move(to: CGPoint(x: w*0.5, y: h))
        path.addCurve(to: CGPoint(x: w*0.1, y: h*0.4), control1: CGPoint(x: w*0.1, y: h*0.9), control2: CGPoint(x: -w*0.1, y: h*0.6))
        path.addCurve(to: CGPoint(x: w*0.5, y: 0), control1: CGPoint(x: w*0.2, y: h*0.2), control2: CGPoint(x: w*0.4, y: h*0.1))
        path.addCurve(to: CGPoint(x: w*0.5, y: h), control1: CGPoint(x: w*0.9, y: h*0.1), control2: CGPoint(x: w*0.9, y: h*0.8))
        path.closeSubpath()
        return path
    }
}

// --- 6. BLESK (Energy) ---
struct BoltShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width; let h = rect.height
        path.move(to: CGPoint(x: w*0.55, y: 0)); path.addLine(to: CGPoint(x: w*0.2, y: h*0.55)); path.addLine(to: CGPoint(x: w*0.45, y: h*0.55)); path.addLine(to: CGPoint(x: w*0.35, y: h)); path.addLine(to: CGPoint(x: w*0.8, y: h*0.40)); path.addLine(to: CGPoint(x: w*0.55, y: h*0.40)); path.closeSubpath()
        return path
    }
}

// --- 7. TERČ (Target) ---
struct BullseyeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY); let r = min(rect.width, rect.height)/2
        path.addEllipse(in: CGRect(x: c.x-r, y: c.y-r, width: r*2, height: r*2))
        path.addEllipse(in: CGRect(x: c.x-(r*0.4), y: c.y-(r*0.4), width: r*0.8, height: r*0.8))
        return path
    }
}

// --- 8. HVĚZDA (Star) ---
struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.width/2, y: rect.height/2); let r = rect.width/2
        return Path { p in
            for i in 0..<10 {
                let a = (Double(i)*(360.0/10.0))-90.0; let rad = (i%2==0) ? r : r*0.4
                let x = c.x + CGFloat(cos(a * .pi/180))*rad; let y = c.y + CGFloat(sin(a * .pi/180))*rad
                if i==0 { p.move(to: CGPoint(x:x,y:y)) } else { p.addLine(to: CGPoint(x:x,y:y)) }
            }
            p.closeSubpath()
        }
    }
}

// --- 9. VRSTVY (Layers) ---
struct LayersShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width; let h = rect.height
        path.addRoundedRect(in: CGRect(x: w*0.2, y: h*0.7, width: w*0.6, height: h*0.25), cornerSize: CGSize(width: 4, height: 4))
        path.addRoundedRect(in: CGRect(x: w*0.1, y: h*0.35, width: w*0.8, height: h*0.25), cornerSize: CGSize(width: 4, height: 4))
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: w, height: h*0.25), cornerSize: CGSize(width: 4, height: 4))
        return path
    }
}

// --- 10. DOKUMENT (Doc) ---
struct DocShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width; let h = rect.height
        // Obrys
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: w*0.1, height: h*0.1))
        // Linky (POZOR: zde již bez 'in:', což opravuje tu chybu z minula)
        path.addRect(CGRect(x: w*0.2, y: h*0.3, width: w*0.6, height: h*0.1))
        path.addRect(CGRect(x: w*0.2, y: h*0.5, width: w*0.6, height: h*0.1))
        path.addRect(CGRect(x: w*0.2, y: h*0.7, width: w*0.4, height: h*0.1))
        return path
    }
}
struct BookShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Středový hřbet (mírně prohnutý)
        path.move(to: CGPoint(x: w/2, y: h*0.15))
        path.addQuadCurve(to: CGPoint(x: w/2, y: h*0.85), control: CGPoint(x: w/2 - w*0.02, y: h*0.5))
        
        // Levá stránka
        path.move(to: CGPoint(x: w/2, y: h*0.15))
        path.addQuadCurve(to: CGPoint(x: w*0.05, y: h*0.25), control: CGPoint(x: w*0.25, y: h*0.05))
        path.addLine(to: CGPoint(x: w*0.05, y: h*0.85))
        path.addQuadCurve(to: CGPoint(x: w/2, y: h*0.85), control: CGPoint(x: w*0.25, y: h*0.65))
        
        // Pravá stránka (zrcadlově)
        path.move(to: CGPoint(x: w/2, y: h*0.15))
        path.addQuadCurve(to: CGPoint(x: w*0.95, y: h*0.25), control: CGPoint(x: w*0.75, y: h*0.05))
        path.addLine(to: CGPoint(x: w*0.95, y: h*0.85))
        path.addQuadCurve(to: CGPoint(x: w/2, y: h*0.85), control: CGPoint(x: w*0.75, y: h*0.65))
        
        // Spodní tloušťka stránek
        path.move(to: CGPoint(x: w*0.05, y: h*0.85))
        path.addQuadCurve(to: CGPoint(x: w*0.1, y: h*0.95), control: CGPoint(x: w*0.05, y: h*0.95))
        path.addQuadCurve(to: CGPoint(x: w/2, y: h*0.9), control: CGPoint(x: w*0.3, y: h*0.75))
        
        path.move(to: CGPoint(x: w*0.95, y: h*0.85))
        path.addQuadCurve(to: CGPoint(x: w*0.9, y: h*0.95), control: CGPoint(x: w*0.95, y: h*0.95))
        path.addQuadCurve(to: CGPoint(x: w/2, y: h*0.9), control: CGPoint(x: w*0.7, y: h*0.75))
        
        return path
    }}
