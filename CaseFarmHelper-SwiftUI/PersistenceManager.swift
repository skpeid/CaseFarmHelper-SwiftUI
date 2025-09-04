//
//  PersistenceManager.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 03.09.2025.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let accountsFile = "accounts.json"
    private static let dropsFile = "drops.json"
    private static let tradesFile = "trades.json"
    
    init() {
        encoder.outputFormatting = .prettyPrinted
    }
    
    private static func fileURL(for filename: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - Accounts Persistence
    func saveAccount(_ accounts: [AccountDTO]) {
        do {
            let data = try encoder.encode(accounts)
            try data.write(to: FileManager.accountsURL)
            print("Account saved")
        } catch {
            print("Failed to save accounts", error)
        }
    }
    
    func loadAccounts() -> [AccountDTO] {
        do {
            let data = try Data(contentsOf: FileManager.accountsURL)
            return try decoder.decode([AccountDTO].self, from: data)
        } catch {
            print("Failed to load accounts", error)
            return []
        }
    }
    
    func deleteAccountsFile() {
        let url = getDocumentsDirectory().appendingPathComponent(accountsFile)
        do {
            try FileManager.default.removeItem(at: url)
            print("accounts.json deleted")
        } catch {
            print("Couldn't delete accounts.json", error)
        }
    }
    
    // MARK: - Drops
    static func saveDrop(_ drops: [DropDTO]) {
        let url = fileURL(for: dropsFile)
        do {
            let data = try JSONEncoder().encode(drops)
            try data.write(to: url)
        } catch {
            print("Failed to save drops", error)
        }
    }
    
    static func loadDrops() -> [DropDTO] {
        let url = fileURL(for: dropsFile)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([DropDTO].self, from: data)
        } catch {
            print("Failed to load drops", error)
            return []
        }
    }
    
    // MARK: - Trades
    static func saveTrades(_ trades: [TradeDTO]) {
        let url = fileURL(for: tradesFile)
        do {
            let data = try JSONEncoder().encode(trades)
            try data.write(to: url)
        } catch {
            print("Failed to save trades", error)
        }
    }
    
    static func loadTrades() -> [TradeDTO] {
        let url = fileURL(for: tradesFile)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([TradeDTO].self, from: data)
        } catch {
            print("Failed to load trades", error)
            return []
        }
    }
    
    func deleteOperationsFromStorage() {
        let dropsURL = getDocumentsDirectory().appendingPathComponent("drops.json")
        let tradesURL = getDocumentsDirectory().appendingPathComponent("trades.json")
        
        do {
            if FileManager.default.fileExists(atPath: dropsURL.path) {
                try FileManager.default.removeItem(at: dropsURL)
            }
            if FileManager.default.fileExists(atPath: tradesURL.path) {
                try FileManager.default.removeItem(at: tradesURL)
            }
        } catch {
            print("Error deleting operations", error)
        }
    }
}
