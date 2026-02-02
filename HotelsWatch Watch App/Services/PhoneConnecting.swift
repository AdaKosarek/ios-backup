//
//  PhoneConnecting.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import WatchConnectivity

protocol PhoneConnecting {
    func session(_ session: WCSession, didReceiveMessage message: [String: Any])

    //odeslani
    func sendIncrementCounter(id: UUID)
}
