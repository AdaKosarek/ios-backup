//
//  ListView.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import SwiftUI
import MapKit

struct ListView: View {
    @State private var viewModel: ListViewModel
    @State private var isDetailPresented = false
    @State private var isNewEntryViewPresented = false

    @EnvironmentObject var container: DIContainer

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationStack {
            VStack {
                headerView
                mapView
            }
            
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        isNewEntryViewPresented.toggle()
                    } label: {
                        Label("Add Hotel", systemImage: "plus")
                            .labelStyle(.iconOnly)
                    }
                }
            }
            .sheet(isPresented: $isDetailPresented) {
                if let selectedEntry = viewModel.state.selectedEntry {
                    NavigationStack {
                        DetailView(
                            viewModel: DetailViewModel(
                                entry: selectedEntry,
                                dataManager: container.resolve()
                            )
                        )
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Close") {
                                    isDetailPresented = false
                                }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isNewEntryViewPresented) {
                NavigationStack {
                    NewEntryView(
                        isNewEntryViewPresented: $isNewEntryViewPresented,
                        viewModel: viewModel,
                        watchConnector: container.resolve()
                    )
                }
            }
            .onAppear {
                viewModel.fetchEntries()
                viewModel.syncLocation()
                
                Task {
                    await viewModel.startPeriodicLocationUpdate()
                }
            }//.navigationTitle("Hotels")
            .task {
                await startPeriodicViewUpdates()
            }
        }
    }
}


private extension ListView {
    var mapView: some View {
        Map(
            position: $viewModel.state.mapCameraPosition,
            interactionModes: [.pan, .zoom]
        ) {
            ForEach(viewModel.state.entries) { entry in
                Annotation(
                    "",
                    coordinate: entry.coordinates
                ) {
                    VStack(spacing: 4) {

                        // PIN
                        HotelPinView()
                        /*
                        Image(systemName: "building.2.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)*/

                        // INFO POD PINEM
                        VStack(spacing: 2) {
                            Text(entry.name)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .lineLimit(1)

                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundStyle(.yellow)

                                Text("(\(entry.rating))")
                                    .font(.caption2)
                            }
                        }
                        .padding(6)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .onTapGesture {
                        viewModel.state.selectedEntry = entry
                        isDetailPresented = true
                    }
                }
            }
        }
    }
    
    var headerView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Hotels")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
    }

    
    func startPeriodicViewUpdates() async {
        while true {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            viewModel.fetchEntries()
        }
    }
}

