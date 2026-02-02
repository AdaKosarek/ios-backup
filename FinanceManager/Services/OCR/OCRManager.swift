//
//  OCRManager.swift
//  FinanceManager
//
//  Created by mp on 13.06.2025.
//

import UIKit
import Vision

final class OCRManager: OCRManaging {
    func recognizeText(from image: UIImage, completion: @escaping ([String]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                print("OCR chyba: \(error!.localizedDescription)")
                completion([])
                return
            }

            let lines = request.results?
                .compactMap { $0 as? VNRecognizedTextObservation }
                .compactMap { $0.topCandidates(1).first?.string } ?? []

            completion(lines)
        }

        request.recognitionLevel = .accurate

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("OCR processing error: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
