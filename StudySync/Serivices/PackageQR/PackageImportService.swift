//
//  PackageImportService.swift
//  StudySync
//
//  Created by mp on 24.01.2026.
//
import SwiftUI

final class PackageImportService {

    private let dataService: DataServiceProtocol

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    func importFromQR(_ payload: String) throws {
        guard let data = Data(base64Encoded: payload) else {
            throw ImportError.invalidQR
        }

        let dto = try JSONDecoder().decode(PackageDTO.self, from: data)

        let package = StudyPackage(
            name: dto.name,
            colorHex: dto.colorHex
        )

        dto.groups.forEach { g in
            let group = StudyGroup(name: g.name)

            g.cards.forEach { c in
                let card = StudyCard(
                    question: c.question,
                    answer: c.answer
                )
                group.cards.append(card)
            }

            package.groups.append(group)
        }

        dataService.addPackage(package)
    }

    enum ImportError: Error {
        case invalidQR
    }
}
