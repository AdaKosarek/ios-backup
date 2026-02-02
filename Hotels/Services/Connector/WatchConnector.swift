//
//  WatchConnector.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import WatchConnectivity
import _LocationEssentials

final class WatchConnector: NSObject, WatchConnecting {

    private let session: WCSession
    private let dataManager: DataManaging //prijem z watchos
    
    init(
        session: WCSession = .default,
        dataManager: DataManaging
    ) {
        self.session = session
        self.dataManager = dataManager
        super.init()

        self.session.delegate = self
        self.session.activate()
    }

    func sendEntryToWatch(_ entry: Entry) {
        guard session.isReachable else { return }

        let payload: [String: Any] = [
            "id": entry.id.uuidString,
            "name": entry.name,
            "type": entry.type.rawValue,
            "date": entry.date,
            "avalibility": entry.availability,
            "rating": entry.rating,
            "counter": entry.counter,
            "latitude": entry.coordinates.latitude,
            "longitude": entry.coordinates.longitude,
            "locationName": entry.locationName
        ]

        session.sendMessage(payload, replyHandler: nil)
    }
}

extension WatchConnector: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    //!prijem z watchos
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        guard
            let action = message["action"] as? String,
            action == "incrementCounter",
            let idString = message["id"] as? String,
            let id = UUID(uuidString: idString)
        else {
            return
        }

        handleIncrementCounter(id: id)
    }
    
    func handleIncrementCounter(id: UUID) {
        DispatchQueue.main.async {
            guard let building = self.dataManager.fetchBuildingWithId(id: id) else {
                return
            }
            
            building.counter += 1
            self.dataManager.saveBuilding(building: building)
            
            print("iOS: counter incremented for \(id)")
        }
    }
}
