//
//  NewEntryView.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import SwiftUI
import CoreLocation

struct NewEntryView: View {
    @Binding var isNewEntryViewPresented: Bool
    @State var viewModel: ListViewModel
    private let watchConnector: WatchConnecting
    
    @State private var type: EntryType = .Resort
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date()
    @State private var name: String = ""
    @State private var rating: Double = 3
    
    //map picker
    @State private var isMapPickerPresented = false
    @State private var selectedCoordinates: CLLocationCoordinate2D?
    @State private var locationName: String = ""
    
    //kvuli watch, jinak netreba
    init(
        isNewEntryViewPresented: Binding<Bool>,
        viewModel: ListViewModel,
        watchConnector: WatchConnecting
    ) {
        self._isNewEntryViewPresented = isNewEntryViewPresented
        self.viewModel = viewModel
        self.watchConnector = watchConnector
    }
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("", text: $name)
            }
            Section("Type") {
                Picker("Entry type", selection: $type) {
                    ForEach(EntryType.allCases) { option in
                        Text(option.name)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section("Date") {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
            }
            Section("Time") {
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.compact)
            }
            
            //posuvnik
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Rating (\(Int(rating)))")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Slider(
                        value: $rating,
                        in: 1...5,
                        step: 1
                    )
                }
                .padding(.vertical, 4)
            }

            //map
            Section("Location") {
                Button {
                    viewModel.syncLocation()
                    isMapPickerPresented = true
                } label: {
                    HStack {
                        Text(locationName.isEmpty ? "Select location" : locationName)
                        Spacer()
                        Image(systemName: "map")
                    }
                }

                if let selectedCoordinates {
                    HStack {
                        Text("Lat: \(selectedCoordinates.latitude)")
                        Spacer()
                        Text("Lon: \(selectedCoordinates.longitude)")
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }

            
        }
        .navigationTitle("Add Hotel")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    isNewEntryViewPresented = false
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveEntry()
                    isNewEntryViewPresented = false
                }
            }
        }
        .sheet(isPresented: $isMapPickerPresented) { //mappicker
            MapPickerView(
                cameraPosition: $viewModel.state.mapCameraPosition
            ) { coordinate in
                selectedCoordinates = coordinate
                viewModel.resolvePlaceName(from: coordinate) { resolvedName in
                    locationName = resolvedName
                }
            }
        }
    }

    private func combinedDate() -> Date {
        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: selectedDate
        )

        let timeComponents = calendar.dateComponents(
            [.hour, .minute],
            from: selectedTime
        )

        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute

        return calendar.date(from: components) ?? Date()
    }

    
    private func saveEntry() {
        guard let selectedCoordinates else { return }
        
        let finalDate = combinedDate()
        viewModel.addEntry(
            name: name,
            type: type,
            date: finalDate,
            coordinates: selectedCoordinates,
            locationName: locationName.isEmpty ? "Unknown location" : locationName,
            rating: Int16(rating)
        )
        
        //pro watchos
        let entry = Entry(
            id: UUID(),
            name: name,
            type: type,
            date: finalDate,
            availability: false,
            rating: Int16(rating),
            counter: 0,
            coordinates: selectedCoordinates,
            locationName: locationName.isEmpty ? "Unknown location" : locationName
        )
        watchConnector.sendEntryToWatch(entry)
    }
}
