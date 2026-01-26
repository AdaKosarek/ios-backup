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

    override func setUp() {
        super.setUp()
        mockService = MockDataService()
    
        viewModel = PackagesListViewModel(dataService: mockService!)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func test_AddPackage_ShouldAddPackageToServiceAndReload() {
        let name = "Matematika"
        let color = "red"
        let icon = "book"
        
        viewModel.addPackage(name: name, color: color, icon: icon)
        
        XCTAssertEqual(mockService.packages.count, 1)
        XCTAssertEqual(mockService.packages.first?.name, name)
        
        XCTAssertEqual(viewModel.packages.count, 1)
        XCTAssertEqual(viewModel.packages.first?.colorHex, color)
    }
    
    func test_DeletePackage_ShouldRemovePackage() {
        let p1 = StudyPackage(name: "Test 1")
        let p2 = StudyPackage(name: "Test 2")
        mockService.packages = [p1, p2]
        
        viewModel.loadPackages()
        XCTAssertEqual(viewModel.packages.count, 2)
        
        viewModel.deletePackage(at: IndexSet(integer: 0))
        
        XCTAssertEqual(mockService.packages.count, 1)
        XCTAssertEqual(viewModel.packages.count, 1)
        XCTAssertEqual(viewModel.packages.first?.name, "Test 2") // Zbyl ten druhý
    }
    
    func test_InitialState_ShouldBeEmpty() {
        XCTAssertTrue(viewModel.packages.isEmpty)
    }
}
