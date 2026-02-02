//
//  OCRManaging.swift
//  FinanceManager
//
//  Created by mp on 13.06.2025.
//

import UIKit

protocol OCRManaging {
    func recognizeText(from image: UIImage, completion: @escaping ([String]) -> Void)
}
