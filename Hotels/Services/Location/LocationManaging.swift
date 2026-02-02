//
//  LocationManaging.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import MapKit
import SwiftUI

protocol LocationManaging {
    var cameraPosition: MapCameraPosition { get }
    var currentLocation: CLLocationCoordinate2D? { get }
}
