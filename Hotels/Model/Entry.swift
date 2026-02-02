//
//  Entry.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import UIKit
import CoreLocation
import SwiftUI

struct Entry: Identifiable {
    var id: UUID
    var name: String
    var type: EntryType
    var date: Date
    var availability: Bool
    var rating: Int16
    var counter: Int16
    
    var coordinates: CLLocationCoordinate2D //
    var locationName: String
}

enum EntryType: Int16, CaseIterable, Identifiable {
    var id: Self { self }
    
    case Resort = 1
    case Luxury = 2
    case Motel = 3
    
    var name: String {
        String(describing: self)
    }
    
    //pro typ barevny
    var color: Color {
        switch self {
        case .Resort:
            return .blue
        case .Luxury:
            return .green
        case .Motel:
            return .red
        }
    }
}
