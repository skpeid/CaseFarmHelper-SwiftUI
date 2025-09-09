//
//  SteamMarketService.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 08.09.2025.
//

import Foundation

final class SteamMarketService {
    private let appID = 730
    private let currencyID = 37
    
    func fetchPrice(for csCase: CSCase) async throws -> CasePrice {
        let url = URL(string: "https://steamcommunity.com/market/priceoverview/?appid=\(appID)&currency=\(currencyID)&market_hash_name=\(csCase.marketHashName)")
        guard let url = url else {
            fatalError("Invalid URL")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(CasePrice.self, from: data)
    }
}
