//
//  LocationManager.swift
//  FinanceManager
//
//  Created by mp on 14.06.2025.
//

import MapKit
import SwiftUI
import CoreLocation

@Observable
final class LocationManager: NSObject, LocationManaging, CLLocationManagerDelegate {
    private var manager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?

    var onLocationUpdate: (() -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let actLocation = locations.last {
            currentLocation = actLocation.coordinate
            onLocationUpdate?()
        }
    }
}

