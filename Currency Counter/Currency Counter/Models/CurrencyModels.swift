//
//  CurrencyModels.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 16.10.2024.
//

import Foundation

struct CurrencyResponse: Decodable {
    let success: Bool
    let source: String
    let quotes: [String: Double]
}

struct ConvertResponse: Codable {
    let success: Bool
    let result: Double
}

struct Currency: Identifiable {
    let id = UUID()
    let code: String
    let rate: Double
}

