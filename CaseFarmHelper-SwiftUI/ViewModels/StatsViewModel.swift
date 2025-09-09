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
}
