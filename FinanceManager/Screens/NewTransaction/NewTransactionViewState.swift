//
//  NewTransactionState.swift
//  FinanceManager
//
//  Created by mp on 13.06.2025.
//
import Observation
import SwiftUI
import MapKit

@Observable
final class NewTransactionViewState {
    var title: String = ""
    var amount: String = ""
    var date: Date = Date()
    var isExpense: Bool = true
    var selectedCategory: CategoryModel?
    var location: String = ""
    var receiptImage: UIImage? = nil
    var autoFillEnabled: Bool = true
    
    var currentLocation: CLLocationCoordinate2D?
}
