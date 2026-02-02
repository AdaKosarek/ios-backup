//
//  ListViewState.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import Observation
import SwiftUI
import MapKit

@Observable
final class ListViewState {
    var entries: [Entry] = []
    var selectedEntry: Entry?

   var mapCameraPosition: MapCameraPosition = .camera(
       .init(
           centerCoordinate: .init(
               latitude: 49.21044343932761,
               longitude: 16.6157301199077
           ),
           distance: 3000
       )
   )
}
