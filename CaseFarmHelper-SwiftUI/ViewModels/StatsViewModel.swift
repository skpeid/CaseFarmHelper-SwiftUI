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
                print("Fetched \(csCase.displayName): \(String(describing: price.lowestPrice))")
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        print("Final casePrices count: \(casePrices.count)")
    }
    
    func fetchCase(for cases: Set<CSCase>) async {
        guard !cases.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        for csCase in cases {
            do {
                let price = try await service.fetchPrice(for: csCase)
                casePrices[csCase] = price
                print("Fetched \(csCase.displayName): \(String(describing: price.lowestPrice))")
            } catch {
                errorMessage = error.localizedDescription
                print("Failed fetch \(csCase.displayName): \(error)")
            }
        }
        print("Final casePrices count: \(casePrices.count)")
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
        var total: Double = 0
        
        for purchase in purchases {
            if let casePrice = casePrices[purchase.casePurchased],
               let priceStr = casePrice.lowestPrice {
                
                let cleaned = priceStr
                    .replacingOccurrences(of: "₸", with: "")
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: ",", with: ".")
                
                if let price = Double(cleaned) {
                    total += price * Double(purchase.amount)
                }
            } else {
                print("Missing price for: \(purchase.casePurchased.displayName)")
            }
        }
        return total
    }
}
