//
//  ListView.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//

import SwiftUI

struct ListView: View {
    private let viewModel: ListViewModel
    private let container: DIContainer
    
    
    init(
        viewModel: ListViewModel,
        container: DIContainer
    ) {
        self.viewModel = viewModel
        self.container = container
    }
    
    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 5)) { _ in
                List(viewModel.state.entries) { entry in
                    NavigationLink {
                        DetailView(
                            viewModel: DetailViewModel(
                                entry: entry,
                                dataManager: container.resolve(),
                                connector: container.resolve()
                            )
                        )
                    } label: {
                        VStack(alignment: .leading) {

                            HStack {
                                Text(entry.name)
                                    .font(.headline)

                                Text("(\(entry.rating))")
                                    .font(.headline)
                            }

                            Text(entry.locationName)
                                .font(.caption)
                            Text(entry.counter.description)
                                .font(.caption)

                        }
                    }
                }
            }
            .navigationTitle("Hotels")
        }
        .onAppear {
            viewModel.fetchEntries()
        }
        .task {
            await startPeriodicViewUpdates()
        }
    }
    
    func startPeriodicViewUpdates() async {
        while true {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            viewModel.fetchEntries()
        }
    }
}
