//
//  GeocodingManager.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import CoreLocation

final class GeocodingManager: GeocodingManaging {

    private let geocoder = CLGeocoder()

    func coordinates(
        from placeName: String,
        completion: @escaping (CLLocationCoordinate2D?) -> Void
    ) {
        geocoder.geocodeAddressString(placeName) { placemarks, _ in
            completion(placemarks?.first?.location?.coordinate)
        }
    }

    func placeName(
        from coordinates: CLLocationCoordinate2D,
        completion: @escaping (String?) -> Void
    ) {
        let location = CLLocation(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )

        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            let placemark = placemarks?.first
            let name = [
                placemark?.name,
                placemark?.locality
            ]
            .compactMap { $0 }
            .joined(separator: ", ")

            completion(name.isEmpty ? nil : name)
        }
    }
}
