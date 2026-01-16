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
    
    private override init() {
        super.init()
        // Stejná inicializace jako ve WeatherApp
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    // --- ODESÍLÁNÍ DAT (Použije iOS) ---
    // ZMĚNA: Používáme sendMessageData (stejný princip jako WeatherApp sendMessage, ale pro JSON)
    func sendDataToWatch(packages: [PackageDTO]) {
        // Stejná kontrola jako ve WeatherApp
        if WCSession.default.isReachable {
            do {
                let data = try JSONEncoder().encode(packages)
                
                // sendMessageData je "okamžitá zpráva" s binárními daty
                WCSession.default.sendMessageData(data, replyHandler: nil) { error in
                    print("Chyba odesílání na hodinky: \(error.localizedDescription)")
                }
                print("✅ Odeslána okamžitá zpráva (sendMessageData)")
            } catch {
                print("Chyba při kódování dat: \(error)")
            }
        } else {
            print("⚠️ Hodinky nejsou 'Reachable'. Musí běžet aplikace na hodinkách.")
            // Pokus o aktivaci, kdyby náhodou
            WCSession.default.activate()
        }
    }
    
    // --- ODESÍLÁNÍ VÝSLEDKU (Použijí Hodinky) ---
    func sendResultToPhone(result: SessionResultDTO) {
        if WCSession.default.isReachable {
            do {
                let data = try JSONEncoder().encode(result)
                WCSession.default.sendMessageData(data, replyHandler: nil) { error in
                    print("Chyba odesílání výsledku: \(error.localizedDescription)")
                }
            } catch {
                print("Chyba kódování výsledku")
            }
        }
    }

    // --- PŘÍJEM DAT (Používáme didReceiveMessageData) ---
    // Toto odpovídá metodě sendMessageData
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        // 1. Zkusíme dekódovat Balíčky
        if let packages = try? JSONDecoder().decode([PackageDTO].self, from: messageData) {
            DispatchQueue.main.async {
                self.receivedPackages = packages
                print("⌚️ Hodinky přijaly data (sendMessage): \(packages.count) balíčků")
            }
        }
        
        // 2. Zkusíme dekódovat Výsledek
        if let result = try? JSONDecoder().decode(SessionResultDTO.self, from: messageData) {
            DispatchQueue.main.async {
                print("📱 iPhone přijal výsledek: \(result.correct)/\(result.incorrect)")
            }
        }
    }
    
    // --- Povinné metody WCSessionDelegate (Stejné jako ve WeatherApp) ---
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session aktivována: \(activationState.rawValue)")
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    #endif
}
