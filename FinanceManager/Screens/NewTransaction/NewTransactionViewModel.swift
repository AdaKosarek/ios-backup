//
//  NewTransactionViewModel.swift
//  FinanceManager
//
//  Created by mp on 12.06.2025.
//

import SwiftUI
import CoreLocation

final class NewTransactionViewModel: ObservableObject {
    @Published var allCategories: [CategoryModel] = []
    @Published var state = NewTransactionViewState()
    
    private var dataManager: DataManaging
    private var ocrManager: OCRManaging
    private var locationManager: LocationManaging
    private var currencyManager: CurrencyManager
    
    private var periodicUpdatesRunning = false

    init() {
        dataManager = DIContainer.shared.resolve()
        ocrManager = DIContainer.shared.resolve()
        locationManager = DIContainer.shared.resolve()
        currencyManager = DIContainer.shared.resolve()

        fetchCategories()

        locationManager.onLocationUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.syncLocation()
            }
        }
    }
    var currencyCode: String {
        currencyManager.currencyCode
    }

    func handleImage(_ image: UIImage) {
        state.receiptImage = image

        guard state.autoFillEnabled else { return }

        ocrManager.recognizeText(from: image) { [weak self] lines in
            DispatchQueue.main.async {
                self?.autofill(from: lines)
            }
        }
    }

    private func autofill(from lines: [String]) {
        let regex = try! NSRegularExpression(pattern: "[0-9]+[.,][0-9]{2}")
        var foundNumbers: [Double] = []

        for line in lines {
            let matches = regex.matches(in: line, range: NSRange(line.startIndex..., in: line))
            for match in matches {
                if let range = Range(match.range, in: line) {
                    var numberString = String(line[range])
                    
                    numberString = numberString.replacingOccurrences(of: ",", with: ".")
                    if let value = Double(numberString) {
                        foundNumbers.append(value)
                    }
                }
            }
        }

        if let maxValue = foundNumbers.max() {
            state.amount = String(format: "%.2f", maxValue)
        }

        state.title = lines.first ?? ""
    }



    func fetchCategories() {
        let fetched = dataManager.fetchCategories()
        allCategories = fetched.map {
            CategoryModel(
                id: $0.id ?? UUID(),
                title: $0.title ?? "",
                icon: $0.icon ?? "questionmark",
                color: Color(hex: $0.color ?? "#000000")
            )
        }
    }

    func deleteCategory(_ id: UUID) {
        if let categoryToDelete = dataManager.fetchCategories().first(where: { $0.id == id }) {
            dataManager.removeCategory(category: categoryToDelete)
        }
        fetchCategories()
    }

    func saveTransaction() {
        guard let userAmount = Double(state.amount) else { return }

        let amountInCZK = currencyManager.convertToCZK(amount: userAmount, from: currencyManager.currencyCode)

        let entity = Transaction(context: dataManager.context)
        entity.id = UUID()
        entity.title = state.title
        entity.amount = amountInCZK
        entity.date = state.date
        entity.isExpense = state.isExpense
        entity.location = state.location

        //im
        if let data = state.receiptImage?.jpegData(compressionQuality: 0.8) {
            let filename = "receipt-\(UUID().uuidString).jpg"
            let url = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent(filename)
            do {
                try data.write(to: url)
                entity.receiptImagePath = filename
            } catch {
                print("❌ Cannot save receipt image: \(error.localizedDescription)")
                entity.receiptImagePath = nil
            }
        } else {
            entity.receiptImagePath = nil
        }

        //kat
        if let selected = state.selectedCategory {
            entity.category = dataManager.fetchCategories().first(where: { $0.id == selected.id })
        } else {
            entity.category = nil
        }

        dataManager.saveTransaction(transaction: entity)
    }

    func syncLocation() {
        state.currentLocation = locationManager.currentLocation
    }

    func determineCurrentLocation() async {
        if let coords = locationManager.currentLocation {
            await reverseGeocode(coords)
            return
        }

        let coords = await withCheckedContinuation { continuation in
            locationManager.onLocationUpdate = {
                if let coords = self.locationManager.currentLocation {
                    continuation.resume(returning: coords)
                }
            }
        }

        await reverseGeocode(coords)
    }

    @MainActor
    private func reverseGeocode(_ coords: CLLocationCoordinate2D) async {
        let location = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        let geocoder = CLGeocoder()

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                self.state.location = placemark.locality ?? placemark.name ?? ""
            }
        } catch {
            //
        }
    }
}

