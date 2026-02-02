//
//  MapPickerView.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import SwiftUI
import MapKit

struct MapPickerView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var cameraPosition: MapCameraPosition
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    let onPick: (CLLocationCoordinate2D) -> Void

    var body: some View {
        NavigationStack {
            MapReader { reader in
                Map(position: $cameraPosition, interactionModes: [.pan, .zoom]) {
                    if let selectedCoordinate {
                        Annotation("", coordinate: selectedCoordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .onTapGesture { point in
                    if let coord = reader.convert(point, from: .local) {
                        selectedCoordinate = coord
                    }
                }
            }
            .navigationTitle("Select location")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Confirm") {
                        if let selectedCoordinate {
                            onPick(selectedCoordinate)
                            dismiss()
                        }
                    }
                    .disabled(selectedCoordinate == nil)
                }
            }
        }
    }
}
