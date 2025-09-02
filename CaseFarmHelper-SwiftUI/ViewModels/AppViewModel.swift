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

final class AppViewModel: ObservableObject {
    
    @Published var accounts: [Account] = []
    @Published var operations: [Operation] = []
    
    init() {
        let dummyAcc1 = Account(profileName: "emptyACC", username: "")
        let dummyAcc2 = Account(profileName: "jks", username: "syrazavr", cases: [.revolution:40, .kilowatt:13])
        let dummyAcc3 = Account(profileName: "azino", username: "", cases: [.recoil:1, .fracture:2, .dreamsAndNightmares: 10, .kilowatt: 20, .revolution: 30])
        let dummyAcc4 = Account(profileName: "MAJORKA", username: "Ohnepixel", cases: [.recoil:100, .fracture:100, .dreamsAndNightmares: 100, .kilowatt: 100, .revolution: 100])
        accounts = [dummyAcc1, dummyAcc2, dummyAcc3, dummyAcc4,
                    Account(profileName: "acc1 ", username: ""),
                    Account(profileName: "2222", username: ""),
                    Account(profileName: "3333", username: ""),
                    Account(profileName: "4444", username: ""),
                    Account(profileName: "555555", username: ""),
                    Account(profileName: "666", username: ""),
                    Account(profileName: "777", username: ""),
                    Account(profileName: "8888", username: "")
        ]
        
        operations = [
            Drop(account: dummyAcc1, caseDropped: .dreamsAndNightmares),
            Trade(sender: dummyAcc2, receiver: dummyAcc1, casesTraded: [.recoil: 1]),
            Drop(account: dummyAcc3, caseDropped: .fracture),
            Trade(sender: dummyAcc4, receiver: dummyAcc1, casesTraded: [.recoil:100, .fracture:100, .dreamsAndNightmares: 100, .kilowatt: 100, .revolution: 100])
        ]
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
        operations.append(Drop(account: account, caseDropped: csCase))
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
}
