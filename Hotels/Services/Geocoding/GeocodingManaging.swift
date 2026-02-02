//
//  GeocodingManaging.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import CoreLocation

protocol GeocodingManaging {
    func coordinates(from placeName: String, completion: @escaping (CLLocationCoordinate2D?) -> Void)
    func placeName(from coordinates: CLLocationCoordinate2D, completion: @escaping (String?) -> Void)
}
