//
//  DetailView.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import SwiftUI
import WatchConnectivity

struct DetailView: View {

    @State private var viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 12) {

            Text(viewModel.state.entry.name)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("Counter: \(viewModel.state.entry.counter)")
                .font(.caption)

            Button("Add +1") {
                viewModel.incrementCounter()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Detail")
    }
}
