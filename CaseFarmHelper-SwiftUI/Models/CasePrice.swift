//
//  CasePrice.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 08.09.2025.
//

import Foundation

struct CasePrice: Codable {
    let success: Bool
    let lowestPrice: String?
    let medianPrice: String?
    let volume: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case lowestPrice = "lowest_price"
        case medianPrice = "median_price"
        case volume
    }
}
