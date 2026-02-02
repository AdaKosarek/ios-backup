//
//  ContentView.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import SwiftUI

struct ContentView: View {
    private let container = DIContainer.shared
    
    var body: some View {
        ListView(
            viewModel: ListViewModel(
                dataManager: container.resolve(),
                geocodingManager: container.resolve(),
                locationManager: container.resolve()
            )
        )
        .environmentObject(container)
    }
}
