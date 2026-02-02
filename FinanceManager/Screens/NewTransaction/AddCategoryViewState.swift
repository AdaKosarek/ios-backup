//
//  AddCategoryViewState.swift
//  FinanceManager
//
//  Created by mp on 14.06.2025.
//
import Observation
import SwiftUI

@Observable
final class AddCategoryViewState {
    var title: String = ""
    var selectedIcon: String = "tag.fill"
    var selectedColor: Color = .purple
}
