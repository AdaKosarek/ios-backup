//
//  CardListViewModel.swift
//  StudySync
//
//  Created by Martin Reich on 16.01.2026.
//

import Foundation
import Observation

@Observable
class CardListViewModel {
    private let dataService: DataServiceProtocol
    var group: StudyGroup
    
    init(group: StudyGroup, dataService: DataServiceProtocol) {
        self.group = group
        self.dataService = dataService
    }
    
    func addCard(question: String, answer: String) {
        dataService.addCard(to: group, question: question, answer: answer)
    }
    
    func deleteCard(at offsets: IndexSet) {
        for index in offsets {
            let card = group.cards[index]
            dataService.deleteCard(card)
        }
    }
}
