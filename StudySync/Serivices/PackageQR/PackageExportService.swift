//
//  PackageExportService.swift
//  StudySync
//
//  Created by mp on 26.01.2026.
//

import CoreImage.CIFilterBuiltins
import SwiftUI
import CoreImage

final class PackageExportService {
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    func makeQRString(from package: StudyPackage) throws -> String {
        let dto = PackageDTO(
            id: package.id,
            name: package.name,
            colorHex: package.colorHex,
            groups: package.groups.map { group in
                GroupDTO(
                    id: group.id,
                    name: group.name,
                    cards: group.cards.map { card in
                        CardDTO(
                            id: card.id,
                            question: card.question,
                            answer: card.answer
                        )
                    }
                )
            }
        )

        let data = try JSONEncoder().encode(dto)
        return data.base64EncodedString()
    }

    func makeQRImage(from payload: String) -> Image {
        filter.setValue(Data(payload.utf8), forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else {
            return Image(systemName: "xmark.circle")
        }

        let scale: CGFloat = 8
        let scaledImage = outputImage.transformed(
            by: CGAffineTransform(scaleX: scale, y: scale)
        )
        let quietZone: CGFloat = 20
        let extentWithQuietZone = scaledImage.extent
            .insetBy(dx: -quietZone, dy: -quietZone)

        guard let cgImage = context.createCGImage(
            scaledImage,
            from: extentWithQuietZone
        ) else {
            return Image(systemName: "xmark.circle")
        }

        return Image(decorative: cgImage, scale: 1)
    }
}

