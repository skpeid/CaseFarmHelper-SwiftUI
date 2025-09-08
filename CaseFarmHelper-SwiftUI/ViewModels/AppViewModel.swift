//
//  ViewModel.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

enum TradeError: LocalizedError {
    case sameAccounts
    case emptySelection
    case notEnoughCases(csCase: CSCase, have: Int, want: Int)
    
    var errorDescription: String? {
        switch self {
        case .sameAccounts: return "Can't send to yourself"
        case .emptySelection: return "Choose at least 1 case"
        case let .notEnoughCases(csCase, have, want): return "\(csCase.displayName): have \(have), want \(want)"
        }
    }
}

@MainActor
final class AppViewModel: ObservableObject {
    
    @Published var accounts: [Account] = []
    var operations: [Operation] {
        (drops as [Operation] + trades as [Operation])
            .sorted { $0.date > $1.date }
    }
    
    @Published var drops: [Drop] = []
    @Published var trades: [Trade] = []
    
    init() {
        loadAccounts()
        loadOperations(accounts: accounts)
    }
    
    func saveOperations() {
        PersistenceManager.saveDrop(drops.map { $0.toDTO() })
        PersistenceManager.saveTrades(trades.map { $0.toDTO() })
    }
    
    func loadOperations(accounts: [Account]) {
        let dropDTOs = PersistenceManager.loadDrops()
        let tradeDTOs = PersistenceManager.loadTrades()
        
        self.drops = dropDTOs.compactMap { Drop.fromDTO($0, accounts: accounts) }
        self.trades = tradeDTOs.compactMap { Trade.fromDTO($0, accounts: accounts) }
    }
    
    func loadAccounts() {
        let dtos = PersistenceManager.shared.loadAccounts()
        accounts = dtos.map { dto in
            Account(id: dto.id,
                    profileName: dto.profileName,
                    username: dto.username,
                    cases: dto.cases.reduce(into: [:], { dict, pair in
                if let csCase = CSCase(rawValue: pair.key) {
                    dict[csCase] = pair.value
                }
            }),
                    profileImage: dto.profileImage.flatMap { UIImage(data: $0) }
            )
        }
    }
    
    func saveAccounts() {
        let dtos = accounts.map { acc in
            AccountDTO(id: acc.id,
                       profileName: acc.profileName,
                       username: acc.username,
                       cases: acc.cases.mapKeys { $0.rawValue },
                       profileImage: acc.profileImage?.pngData()
            )
        }
        PersistenceManager.shared.saveAccount(dtos)
    }
    
    func validateTrade(from: Account?, to: Account?, cases: [CSCase: Int]) -> TradeError? {
        guard let from, let to else { return .emptySelection }
        guard from.id != to.id else { return .sameAccounts }
        
        let filtered = cases.filter { $0.value > 0 }
        guard !filtered.isEmpty else { return .emptySelection }
        
        for (csCase, amount) in filtered {
            let have = from.cases[csCase, default: 0]
            if amount > have {
                return .notEnoughCases(csCase: csCase, have: have, want: amount)
            }
        }
        
        return nil
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
    }
    
    func addDrop(to account: Account, csCase: CSCase) {
        account.cases[csCase, default: 0] += 1
        account.lastDropDate = Date()
        
        let newDrop = Drop(account: account, caseDropped: csCase, date: Date())
        drops.append(newDrop)
        saveAccounts()
        saveOperations()
    }
    
    func performTrade(from sender: Account, to receiver: Account, cases: [CSCase: Int]) throws {
        if let error = validateTrade(from: sender, to: receiver, cases: cases) { throw error }
        
        for (csCase, amount) in cases where amount > 0 {
            let have = sender.cases[csCase, default: 0]
            let send = min(amount, have)
            sender.cases[csCase] = have - send
            receiver.cases[csCase] = receiver.cases[csCase, default: 0] + send
        }
    }
    
    func deleteOperations() {
        drops.removeAll()
        trades.removeAll()
        PersistenceManager.shared.deleteOperationsFromStorage()
    }
}
