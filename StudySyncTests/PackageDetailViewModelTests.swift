//
//  PackageDetailViewModelTests.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import XCTest
@testable import StudySync

@MainActor
final class PackageDetailViewModelTests: XCTestCase {
    
    var viewModel: PackageDetailViewModel!
    var mockService: MockDataService!
    var testPackage: StudyPackage!
    
    override func setUp() {
        super.setUp()
        mockService = MockDataService()
        
        testPackage = StudyPackage(name: "Test Package")
        mockService.packages.append(testPackage)
        
        viewModel = PackageDetailViewModel(package: testPackage, dataService: mockService!)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        testPackage = nil
        super.tearDown()
    }
    
    func test_AddGroup_ShouldAddGroupToPackage() {
        viewModel.addGroup(name: "Geometrie")
        
        XCTAssertEqual(testPackage.groups.count, 1)
        XCTAssertEqual(testPackage.groups.first?.name, "Geometrie")
    }
    
    func test_AddGroup_WithEmptyName_ShouldNotAdd() {
        viewModel.addGroup(name: "")
        
        XCTAssertEqual(testPackage.groups.count, 0)
    }
    
    func test_DeleteGroup_ShouldRemoveGroup() {
        let g1 = StudyGroup(name: "Group 1")
        let g2 = StudyGroup(name: "Group 2")
        testPackage.groups = [g1, g2]
        
        viewModel.deleteGroup(at: IndexSet(integer: 0))
        
        XCTAssertEqual(testPackage.groups.count, 1)
        XCTAssertEqual(testPackage.groups.first?.name, "Group 2")
    }
    
    func test_AllCards_ShouldAggregateCardsFromAllGroups() {
        
        let groupA = StudyGroup(name: "A")
        groupA.cards.append(StudyCard(question: "Q1", answer: "A1"))
        groupA.cards.append(StudyCard(question: "Q2", answer: "A2"))
        
        let groupB = StudyGroup(name: "B")
        groupB.cards.append(StudyCard(question: "Q3", answer: "A3"))
        
        testPackage.groups = [groupA, groupB]
    
        XCTAssertEqual(viewModel.allCards.count, 3)
    }
}
