//
//  PackageQRExportView.swift
//  StudySync
//
//  Created by mp on 24.01.2026.
//

import SwiftUI

struct PackageQRExportView: View {

    let package: StudyPackage
    let exportService: PackageExportService

    @State private var qrImage: Image?

    var body: some View {
        VStack(spacing: 24) {
            Text(package.name)
                .font(.title2)
                .fontWeight(.bold)

            if let qrImage {
                qrImage
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
            } else {
                ProgressView()
            }

            Text("qr_info")
                .font(.footnote)
                .foregroundStyle(.primary)
        }
        .padding()
        .onAppear {
            generateQR()
        }
    }

    private func generateQR() {
        do {
            let payload = try exportService.makeQRString(from: package)
            qrImage = exportService.makeQRImage(from: payload)
        } catch {
            print("QR export failed:", error)
        }
    }
}
