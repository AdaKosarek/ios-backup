//
//  DIContainer.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import SwiftUI
import SwiftData
import Combine // 1. PŘIDÁNO: Nutné pro protokol ObservableObject

// 2. ODSTRANĚNO: @MainActor (není nutný pro tento kontejner a blokoval automatickou konformitu)
//@Observable
class DIContainer: ObservableObject {
    
    // Zde držíme náš Service jako protokol -> klíč k testovatelnosti
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    // Factory metody pro ViewModely
    // View si řekne kontejneru: "Vyrob mi ViewModel" a kontejner mu ho dá i se závislostmi.
    
    @MainActor // Můžeme přidat sem, pokud factory metody vytvářejí UI objekty
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
}
