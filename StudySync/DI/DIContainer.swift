//
//  DIContainer.swift
//  StudySync
//
//  Created by mp on 16.01.2026.
//

import SwiftUI
import SwiftData
import Combine


class DIContainer: ObservableObject {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    @MainActor
    func makePackageImportService() -> PackageImportService {
        PackageImportService(dataService: dataService)
    }

    
    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(dataService: dataService)
    }
    
    @MainActor
    func makePackagesListViewModel() -> PackagesListViewModel {
        return PackagesListViewModel(dataService: dataService)
    }
    
    @MainActor
    func makePackageDetailViewModel(package: StudyPackage) -> PackageDetailViewModel {
        return PackageDetailViewModel(package: package, dataService: dataService)
    }
    
    @MainActor
    func makeCardListViewModel(group: StudyGroup) -> CardListViewModel {
        return CardListViewModel(group: group, dataService: dataService)
    }
    
    @MainActor
    func makeSessionViewModel(cards: [StudyCard]) -> SessionViewModel {
        return SessionViewModel(cards: cards, dataService: dataService)
    }
    func makeStatisticsViewModel() -> StatisticsViewModel {
        return StatisticsViewModel(dataService: dataService)
    }
    func makeEditPackageViewModel(package: StudyPackage?) -> EditPackageViewModel {
        return EditPackageViewModel(package: package, dataService: self.dataService)
    }
    
    @MainActor
    func makePackageExportService() -> PackageExportService {
        PackageExportService()
    }
}
