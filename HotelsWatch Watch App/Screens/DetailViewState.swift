//
//  DetailViewState.swift
//  Hotels
//
//  Created by mp on 18.01.2026.
//
import Observation
import SwiftUI

@Observable
final class DetailViewState {
    var entry: Entry

    init(entry: Entry) {
        self.entry = entry
    }
}
