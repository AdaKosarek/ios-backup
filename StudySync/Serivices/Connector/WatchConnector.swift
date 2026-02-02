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
    
    #if os(iOS)
    private var dataService: DataServiceProtocol?

    func configure(dataService: DataServiceProtocol) {
        self.dataService = dataService
        print("watch, WatchConnector configured with DataService")
    }
    #endif
    
    var receivedPackages: [PackageDTO] = []
    var receivedStats: WatchStatsDTO?
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    //a
    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        DispatchQueue.main.async {

            if let data = applicationContext["packages"] as? Data,
               let packages = try? JSONDecoder().decode([PackageDTO].self, from: data) {
                self.receivedPackages = packages
                print("watch, Packages updated: \(packages.count)")
            }

            if let data = applicationContext["stats"] as? Data,
               let stats = try? JSONDecoder().decode(WatchStatsDTO.self, from: data) {
                self.receivedStats = stats
                print("watch, Stats updated")
            }
        }
    }

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        DispatchQueue.main.async {

            if let data = session.receivedApplicationContext["packages"] as? Data,
               let packages = try? JSONDecoder().decode([PackageDTO].self, from: data) {
                self.receivedPackages = packages
                print("Packages loaded on start")
            }

            if let data = session.receivedApplicationContext["stats"] as? Data,
               let stats = try? JSONDecoder().decode(WatchStatsDTO.self, from: data) {
                self.receivedStats = stats
                print("Stats loaded on start")
            }
        }
    }

    func sendDataToWatch(packages: [PackageDTO]) {
        /*guard WCSession.isSupported() else {
            print(" WCSession not supported")
            return
        }*/

        do {
            let data = try JSONEncoder().encode(packages)

            try WCSession.default.updateApplicationContext([
                "packages": data
            ])

            print("Sync uložen (\(packages.count) balíčků)")

        } catch {
            print("Chyba syncu: \(error)")
        }
    }

    func sendStatsToWatch(_ stats: WatchStatsDTO) {
        do {
            let data = try JSONEncoder().encode(stats)
            try WCSession.default.updateApplicationContext([
                "stats": data
            ])
        } catch {
            print("❌ Stats sync error: \(error)")
        }
    }
    
    //watch odeslani
    func sendSessionResult(_ result: SessionResultDTO) {
        guard WCSession.isSupported() else { return }

        do {
            let data = try JSONEncoder().encode(result)

            if WCSession.default.isReachable {
                // ⚡️ iOS aplikace běží → okamžité doručení
                WCSession.default.sendMessage(
                    ["sessionResult": data],
                    replyHandler: nil,
                    errorHandler: { error in
                        print("sendMessage error: \(error)")
                    }
                )
                print("watch, SessionResult sent via sendMessage: \(result.correct)/\(result.incorrect)")
            } else {
                // iOS neběží → uložit na později
                WCSession.default.transferUserInfo(
                    ["sessionResult": data]
                )
                print("watch, SessionResult queued (transferUserInfo): \(result.correct)/\(result.incorrect)")
            }

        } catch {
            print("Failed to encode SessionResult: \(error)")
        }
    }

    
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        handleIncomingSessionResult(message)
    }

    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any]
    ) {
        handleIncomingSessionResult(userInfo)
    }
    
    private func handleIncomingSessionResult(_ userInfo: [String: Any]) {
        guard
            let data = userInfo["sessionResult"] as? Data,
            let result = try? JSONDecoder().decode(SessionResultDTO.self, from: data)
        else {
            print("Invalid sessionResult payload")
            return
        }

        print("phone, SessionResult received")

        #if os(iOS)
        DispatchQueue.main.async {
            let session = StudySession(
                correctCount: result.correct,
                incorrectCount: result.incorrect
            )

            self.dataService?.saveSession(session)
            print("Session saved from Watch: \(result.correct)/\(result.incorrect)")
        }
        #endif
    }

    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    #endif
}
extension WatchConnector {
    func generateMockData() {
        let card1 = CardDTO(id: UUID(), question: "Pes", answer: "Dog")
        let card2 = CardDTO(id: UUID(), question: "Kočka", answer: "Cat")
        let card3 = CardDTO(id: UUID(), question: "Jablko", answer: "Apple")
        
        let group1 = GroupDTO(id: UUID(), name: "Zvířata", cards: [card1, card2])
        let group2 = GroupDTO(id: UUID(), name: "Jídlo", cards: [card3])
        
        let package1 = PackageDTO(id: UUID(), name: "Angličtina", colorHex: "blue", groups: [group1, group2])
        
        let card4 = CardDTO(id: UUID(), question: "2 + 2", answer: "4")
        let group3 = GroupDTO(id: UUID(), name: "Sčítání", cards: [card4])
        
        let package2 = PackageDTO(id: UUID(), name: "Matematika", colorHex: "orange", groups: [group3])
        
        DispatchQueue.main.async {
            self.receivedPackages = [package1, package2]
        }
    }
}
