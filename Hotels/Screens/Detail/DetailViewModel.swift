//
//  DetailViewModel.swift
//  Hotels
//
//  Created by mp on 17.01.2026.

import SwiftUI
import CoreLocation

@Observable
class DetailViewModel{
    var state: DetailViewState
    private var dataManager: DataManaging
    
    init(
        entry: Entry,
        dataManager: DataManaging
    ) {
        state = DetailViewState(entry: entry)
        self.dataManager = dataManager
    }
}
