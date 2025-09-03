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
    
    init() {
        encoder.outputFormatting = .prettyPrinted
    }
    
    func saveAccounts(_ accounts: [AccountDTO]) {
        do {
            let data = try encoder.encode(accounts)
            try data.write(to: FileManager.accountsURL)
            print("Accounts saved")
        } catch {
            print("Failed to save accounts:", error)
        }
    }
    
    func loadAccounts() -> [AccountDTO] {
        do {
            let data = try Data(contentsOf: FileManager.accountsURL)
            return try decoder.decode([AccountDTO].self, from: data)
        } catch {
            print("Failed to load accounts:", error)
            return []
        }
    }
    
    func deleteAccountsFile() {
        let url = getDocumentsDirectory().appendingPathComponent("accounts.json")
        do {
            try FileManager.default.removeItem(at: url)
            print("accounts.json deleted")
        } catch {
            print("couldn't delete accounts.json", error)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
