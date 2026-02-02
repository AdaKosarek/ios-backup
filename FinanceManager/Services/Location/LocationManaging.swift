//
//  LocationManaging.swift
//  FinanceManager
//
//  Created by mp on 14.06.2025.
//

import MapKit
import SwiftUI

protocol LocationManaging {
    var currentLocation: CLLocationCoordinate2D? { get }
    var onLocationUpdate: (() -> Void)? { get set }
}
