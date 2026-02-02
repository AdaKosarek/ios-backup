//
//  DetailView.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import SwiftUI
import MapKit
import _LocationEssentials

struct DetailView: View {
    @State private var viewModel: DetailViewModel
    @State private var visibleStars: Int16 = 0 //animace
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                RowElement(
                    label: "Type",
                    value: viewModel.state.entry.type.name
                )
                
                RowElement(
                    label: "Location name",
                    value: viewModel.state.entry.locationName
                )

                RowElement(
                    label: "Rating",
                    value: viewModel.state.entry.rating.description
                )
                
                //animace
                VStack(alignment: .leading) {
                    Text("Rating")
                        .font(.caption)

                    HStack(spacing: 6) {
                        ForEach(0..<viewModel.state.entry.rating, id: \.self) { index in
                            RatingView()
                                .offset(x: visibleStars > index ? 0 : -40)
                                .opacity(visibleStars > index ? 1 : 0)
                                .animation(
                                    .easeOut(duration: 0.35)
                                        .delay(Double(index) * 0.15),
                                    value: visibleStars
                                )
                        }
                    }
                }
                .onAppear {
                    visibleStars = viewModel.state.entry.rating
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Type indicator")
                        .font(.caption)

                    PentagonShape()
                        .fill(viewModel.state.entry.type.color)
                        .frame(width: 28, height: 28)
                }

                
                RowElement(
                    label: "Date",
                    value: dateOnlyString
                )
                
                RowElement(
                    label: "Time",
                    value: timeOnlyString
                )
                
                RowElement(
                    label: "Counter",
                    value: viewModel.state.entry.counter.description
                )
                
                //tlacitko styl zkouska
                Button {
                    //
                } label: {
                    Text("ZKouska")
                }
                .buttonStyle(.bottomPrimary)
                .padding(.bottom, 24)
            }
        }
        .padding()
        .navigationTitle(viewModel.state.entry.name)
    }
    
    private var dateOnlyString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: viewModel.state.entry.date)
    }

    private var timeOnlyString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: viewModel.state.entry.date)
    }
}
