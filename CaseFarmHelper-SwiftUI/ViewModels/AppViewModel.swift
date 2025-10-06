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
    
    var errorDescription: String? {
        switch self {
        case .sameAccounts: return "Select sender and receiver accounts"
        case .emptySelection: return "Choose at least 1 case"
        }
    }
}

@MainActor
final class AppViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var drops: [Drop] = []
    @Published var trades: [Trade] = []
    @Published var purchases: [Purchase] = []

    var operations: [Operation] {
        (drops as [Operation] + trades as [Operation] + purchases as [Operation]).sorted { $0.date > $1.date }
    }

    init() {
        loadAccounts()
        loadOperations()
    }

    // MARK: - Accounts persistence
    func saveAccounts() {
        let dtos = accounts.map { acc in
            AccountDTO(
                id: acc.id,
                profileName: acc.profileName,
                username: acc.username,
                cases: Dictionary(uniqueKeysWithValues: acc.cases.map { ($0.key.rawValue, $0.value) }),
                profileImage: acc.profileImage?.pngData(),
                lastDropDate: acc.lastDropDate
            )
        }
        PersistenceManager.shared.saveAccounts(dtos)
    }

    func loadAccounts() {
        let dtos = PersistenceManager.shared.loadAccounts()
        accounts = dtos.map { dto in
            Account(
                id: dto.id,
                profileName: dto.profileName,
                username: dto.username,
                cases: dto.cases.reduce(into: [:]) { dict, pair in
                    if let cs = CSCase(rawValue: pair.key) {
                        dict[cs] = pair.value
                    }
                },
                profileImage: dto.profileImage.flatMap { UIImage(data: $0) },
                lastDropDate: dto.lastDropDate
            )
        }
    }

    // MARK: - Operations persistence
    func saveOperations() {
        PersistenceManager.shared.saveDrops(drops.map { $0.toDTO() })
        PersistenceManager.shared.saveTrades(trades.map { $0.toDTO() })
        PersistenceManager.shared.savePurchases(purchases.map { $0.toDTO() })
    }

    func loadOperations() {
        let dropDTOs = PersistenceManager.shared.loadDrops()
        let tradeDTOs = PersistenceManager.shared.loadTrades()
        let purchaseDTOs = PersistenceManager.shared.loadPurchases()
        self.drops = dropDTOs.compactMap { Drop.fromDTO($0, accounts: accounts) }
        self.trades = tradeDTOs.compactMap { Trade.fromDTO($0, accounts: accounts) }
        self.purchases = purchaseDTOs.compactMap { Purchase.fromDTO($0, accounts: accounts) }
    }

    func deleteOperations() {
        drops.removeAll()
        trades.removeAll()
        purchases.removeAll()
        PersistenceManager.shared.deleteOperationsFromStorage()
    }

    // MARK: - App logic
    func addAccount(_ account: Account) {
        accounts.append(account)
        saveAccounts()
    }

    func addDrop(to account: Account, csCase: CSCase) {
        account.cases[csCase, default: 0] += 1
        account.lastDropDate = Date()
        
        let newDrop = Drop(account: account, caseDropped: csCase, date: Date())
        drops.append(newDrop)
        saveAccounts()
        saveOperations()
    }

    func validateTrade(sender: Account?, receiver: Account?, cases: [CSCase: Int]) throws -> (Account, Account, [CSCase: Int]) {
        guard let from = sender, let to = receiver, from != to else {
            throw TradeError.sameAccounts
        }
        let filtered = cases.filter { $0.value > 0 }
        guard !filtered.isEmpty else {
            throw TradeError.emptySelection
        }
        return (from, to, filtered)
    }

    func performTrade(from sender: Account, to receiver: Account, cases: [CSCase: Int]) throws {
        guard sender.id != receiver.id else { throw TradeError.sameAccounts }
        
        for (csCase, amount) in cases where amount > 0 {
            let have = sender.cases[csCase, default: 0]
            let send = min(amount, have)
            sender.cases[csCase] = have - send
            receiver.cases[csCase] = receiver.cases[csCase, default: 0] + send
        }
        
        let newTrade = Trade(sender: sender, receiver: receiver, casesTraded: cases, date: Date())
        trades.append(newTrade)
        saveAccounts()
        saveOperations()
    }
    
    func performPurchase(account: Account, csCase: CSCase, amount: Int, totalCost: Double) {
        account.cases[csCase, default: 0] += amount
        
        let newPurchase = Purchase(date: Date(), account: account, caseBought: csCase, amount: amount, totalCost: totalCost)
        purchases.append(newPurchase)
        saveAccounts()
        saveOperations()
    }

    // MARK: - Stats helpers
    var getTotalCasesAmount: Int {
        accounts.reduce(0) { $0 + $1.cases.values.reduce(0, +) }
    }
}

extension AppViewModel {
    var ownedCases: Set<CSCase> {
        var set = Set<CSCase>()
        for account in accounts {
            for (csCase, amount) in account.cases where amount > 0 {
                set.insert(csCase)
            }
        }
        return set
    }
    
    var tickerCases: Set<CSCase> { Set(CSCase.activeDrop).union(ownedCases) }
}

extension AppViewModel {
    func reloadAccounts() {
        let updatedAccounts = accounts
        accounts = []
        accounts = updatedAccounts
    }
}
