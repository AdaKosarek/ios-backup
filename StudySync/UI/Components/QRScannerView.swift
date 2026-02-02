//
//  QRScannerView.swift
//  StudySync
//
//  Created by mp on 24.01.2026.
//

import SwiftUI
import VisionKit
import Vision

struct QRScannerView: UIViewControllerRepresentable {

    let onScan: (String) -> Void
    let onCancel: () -> Void

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.qr])],
            qualityLevel: .accurate,
            recognizesMultipleItems: false,
            isGuidanceEnabled: true
        )

        scanner.delegate = context.coordinator

        try? scanner.startScanning()

        return scanner
    }

    func updateUIViewController(
        _ uiViewController: DataScannerViewController,
        context: Context
    ) {
        //scanner běží sám
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: QRScannerView

        init(_ parent: QRScannerView) {
            self.parent = parent
        }

        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didTapOn item: RecognizedItem
        ) {
            if case let .barcode(barcode) = item,
               let payload = barcode.payloadStringValue {
                dataScanner.stopScanning()

                parent.onScan(payload)
            }
        }

        func dataScannerDidCancel(_ dataScanner: DataScannerViewController) {
            dataScanner.stopScanning()
            parent.onCancel()
        }
    }
}
