//
//  PersistenceManager.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 03.09.2025.
//

import Foundation

enum PersistenceFile: String {
    case accounts = "accounts.json"
    case drops = "drops.json"
    case trades = "trades.json"
    case purchases = "purchases.json"
}

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        encoder.outputFormatting = .prettyPrinted
    }
    
    private func fileURL(for file: PersistenceFile) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(file.rawValue)
    }
    
    func save<T: Encodable>(_ value: T, to file: PersistenceFile) {
        do {
            let data = try encoder.encode(value)
            try data.write(to: fileURL(for: file))
            print("Saved \(file.rawValue)")
        } catch {
            print("Failed to save \(file.rawValue):", error)
        }
    }
    
    func load<T: Decodable>(_ type: T.Type, from file: PersistenceFile) -> T? {
        do {
            let data = try Data(contentsOf: fileURL(for: file))
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to load \(file.rawValue):", error)
            return nil
        }
    }
    
    func delete(_ file: PersistenceFile) {
        let url = fileURL(for: file)
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
                print("Deleted \(file.rawValue)")
            }
        } catch {
            print("Couldn’t delete \(file.rawValue):", error)
        }
    }
}

extension PersistenceManager {
    
    // Accounts
    func saveAccounts(_ accounts: [AccountDTO]) {
        save(accounts, to: .accounts)
    }
    
    func loadAccounts() -> [AccountDTO] {
        load([AccountDTO].self, from: .accounts) ?? []
    }
    
    func deleteAccountsFile() {
        delete(.accounts)
    }
    
    // Drops
    func saveDrops(_ drops: [DropDTO]) {
        save(drops, to: .drops)
    }
    
    func loadDrops() -> [DropDTO] {
        load([DropDTO].self, from: .drops) ?? []
    }
    
    // Trades
    func saveTrades(_ trades: [TradeDTO]) {
        save(trades, to: .trades)
    }
    
    func loadTrades() -> [TradeDTO] {
        load([TradeDTO].self, from: .trades) ?? []
    }
    
    // Purchases
    func savePurchases(_ purchases: [PurchaseDTO]) {
        save(purchases, to: .purchases)
    }
    
    func loadPurchases() -> [PurchaseDTO] {
        load([PurchaseDTO].self, from: .purchases) ?? []
    }
    
    // Operations (drops + trades + purchases)
    func deleteOperationsFromStorage() {
        delete(.drops)
        delete(.trades)
        delete(.purchases)
    }
}
