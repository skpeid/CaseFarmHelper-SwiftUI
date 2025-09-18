//
//  StatsViewModel.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 08.09.2025.
//

import Foundation

@MainActor
final class StatsViewModel: ObservableObject {
    @Published var casePrices: [CSCase: CasePrice] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = SteamMarketService()
    
    func fetchAllCases() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        for csCase in CSCase.allCases {
            do {
                let price = try await service.fetchPrice(for: csCase)
                casePrices[csCase] = price
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetch(_ csCase: CSCase) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let price = try await service.fetchPrice(for: csCase)
            casePrices[csCase] = price
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func totalValue(from accounts: [Account]) -> Double {
        accounts.reduce(0.0) { total, account in
            total + account.cases.reduce(0.0) { subtotal, pair in
                let (csCase, count) = pair
                guard count > 0 else { return subtotal }
                if let priceStr = casePrices[csCase]?.lowestPrice,
                   let price = priceStr.priceToDouble() {
                    return subtotal + price * Double(count)
                }
                return subtotal
            }
        }
    }
    
    func currentValue(for purchases: [Purchase]) -> Double {
        purchases.reduce(0) { sum, purchase in
            guard let currentPrice = casePrices[purchase.casePurchased]?.lowestPrice?.priceToDouble()
            else { return sum }
            return sum + Double(purchase.amount) * currentPrice
        }
    }
}
