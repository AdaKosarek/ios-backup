//
//  PackagesListViewModelTests.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import XCTest
@testable import StudySync

@MainActor
final class PackagesListViewModelTests: XCTestCase {

    var viewModel: PackagesListViewModel!
    var mockService: MockDataService!

    // Tato metoda se zavolá PŘED každým jedním testem
    override func setUp() {
        super.setUp()
        // 1. Vytvoříme čistý Mock
        mockService = MockDataService()
        
        // 2. Vstříkneme ho do ViewModelu
        // OPRAVA: Přidej '!' za mockService. Tím říkáš: "Vím jistě, že to není nil."
        viewModel = PackagesListViewModel(dataService: mockService!)
    }

    // Tato metoda se zavolá PO každém testu
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func test_AddPackage_ShouldAddPackageToServiceAndReload() {
        // Arrange (Příprava)
        let name = "Matematika"
        let color = "red"
        let icon = "book"
        
        // Act (Akce)
        viewModel.addPackage(name: name, color: color, icon: icon)
        
        // Assert (Ověření)
        // 1. Ověříme, že se to propsalo do "databáze"
        XCTAssertEqual(mockService.packages.count, 1)
        XCTAssertEqual(mockService.packages.first?.name, name)
        
        // 2. Ověříme, že ViewModel si aktualizoval svůj seznam
        XCTAssertEqual(viewModel.packages.count, 1)
        XCTAssertEqual(viewModel.packages.first?.colorHex, color)
    }
    
    func test_DeletePackage_ShouldRemovePackage() {
        // Arrange - nejdřív musíme něco přidat
        let p1 = StudyPackage(name: "Test 1")
        let p2 = StudyPackage(name: "Test 2")
        mockService.packages = [p1, p2]
        
        // Načteme data do VM
        viewModel.loadPackages()
        XCTAssertEqual(viewModel.packages.count, 2)
        
        // Act - smažeme první položku (IndexSet pro řádek 0)
        viewModel.deletePackage(at: IndexSet(integer: 0))
        
        // Assert
        XCTAssertEqual(mockService.packages.count, 1)
        XCTAssertEqual(viewModel.packages.count, 1)
        XCTAssertEqual(viewModel.packages.first?.name, "Test 2") // Zbyl ten druhý
    }
    
    func test_InitialState_ShouldBeEmpty() {
        XCTAssertTrue(viewModel.packages.isEmpty)
    }
}
