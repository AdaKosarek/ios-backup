//
//  PhoneConnector.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import WatchConnectivity
import Foundation
import CoreData

final class PhoneConnector: NSObject, WCSessionDelegate, PhoneConnecting {

    private let session: WCSession
    private let dataManager: DataManaging

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

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

        let building = Building(context: dataManager.context)
        building.id = UUID(uuidString: message["id"] as? String ?? "") ?? UUID()
        building.name = message["name"] as? String ?? "No name"
        building.type = message["type"] as? Int16 ?? EntryType.Resort.rawValue
        building.rating = message["rating"] as? Int16 ?? 0
        building.counter = message["counter"] as? Int16 ?? 0
        building.locationName = message["locationName"] as? String ?? "Unknown place"

        dataManager.saveBuilding(building: building)
    }
}

extension PhoneConnector {
    //odesilani
    func sendIncrementCounter(id: UUID) {
        guard session.isReachable else { return }

        let payload: [String: Any] = [
            "action": "incrementCounter",
            "id": id.uuidString
        ]

        session.sendMessage(payload, replyHandler: nil)
    }
}
