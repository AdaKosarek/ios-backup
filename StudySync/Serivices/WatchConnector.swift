//
//  WatchConnector.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import WatchConnectivity
import Observation

@Observable
class WatchConnector: NSObject, WCSessionDelegate {
    
    static let shared = WatchConnector()
    
    var receivedPackages: [PackageDTO] = []
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // --- ODESÍLÁNÍ DAT (Použije iOS) ---
    // ZMĚNA: Používáme updateApplicationContext místo sendMessage
    func sendDataToWatch(packages: [PackageDTO]) {
        // 1. Aktivace, pokud není
        if WCSession.default.activationState != .activated {
            WCSession.default.activate()
        }
        
        do {
            let data = try JSONEncoder().encode(packages)
            
            // updateApplicationContext funguje i na pozadí a nevyžaduje 'isReachable'
            try WCSession.default.updateApplicationContext(["packagesData": data])
            
            print("✅ Data odeslána do kontextu (bude synchronizováno)!")
        } catch {
            print("❌ Chyba při kódování dat: \(error)")
        }
    }
    
    // --- ODESÍLÁNÍ VÝSLEDKU (Použijí Hodinky) ---
    func sendResultToPhone(result: SessionResultDTO) {
        if WCSession.default.activationState != .activated {
            WCSession.default.activate()
        }
        
        do {
            let data = try JSONEncoder().encode(result)
            // I zpátky použijeme robustnější metodu
            try WCSession.default.updateApplicationContext(["resultData": data])
        } catch {
            print("Chyba kódování výsledku")
        }
    }

    // --- PŘÍJEM DAT (NOVÁ METODA PRO CONTEXT) ---
    // Toto se zavolá, když dorazí data přes updateApplicationContext
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        // 1. Příjem Balíčků (iOS -> Watch)
        if let data = applicationContext["packagesData"] as? Data {
            if let packages = try? JSONDecoder().decode([PackageDTO].self, from: data) {
                DispatchQueue.main.async {
                    self.receivedPackages = packages
                    print("⌚️ Hodinky aktualizovaly data: \(packages.count) balíčků")
                }
            }
        }
        
        // 2. Příjem Výsledku (Watch -> iOS)
        if let data = applicationContext["resultData"] as? Data {
            if let result = try? JSONDecoder().decode(SessionResultDTO.self, from: data) {
                DispatchQueue.main.async {
                    print("📱 iPhone přijal výsledek: \(result.correct)/\(result.incorrect)")
                }
            }
        }
    }
    
    // --- Stará metoda pro přímé zprávy (ponecháme pro jistotu) ---
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        // ... (stejná logika jako nahoře, kdyby náhodou) ...
    }
    
    // --- Povinné metody WCSessionDelegate ---
    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        print("WCSession aktivována: \(state.rawValue)")
        // Po aktivaci můžeme zkusit poslat data znovu, pokud nějaká čekají (volitelné)
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}
