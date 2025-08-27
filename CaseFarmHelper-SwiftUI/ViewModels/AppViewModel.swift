//
//  ViewModel.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

final class AppViewModel: ObservableObject {
    
    @Published var accounts: [Account] = []
    @Published var operations: [Operation] = []
    
    init() {
        let dummyAcc1 = Account(profileName: "emptyACC", username: "")
        let dummyAcc2 = Account(profileName: "jks", username: "syrazavr", cases: [.revolution:40, .kilowatt:13])
        let dummyAcc3 = Account(profileName: "azino", username: "", cases: [.recoil:1, .fracture:2, .dreamsAndNightmares: 10, .kilowatt: 20, .revolution: 30])
        accounts = [dummyAcc1, dummyAcc2, dummyAcc3]
        
        operations = [
            Drop(account: dummyAcc1, caseDropped: .dreamsAndNightmares),
            Trade(sender: dummyAcc2, receiver: dummyAcc1, caseTraded: .recoil),
            Drop(account: dummyAcc3, caseDropped: .fracture)
        ]
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
    }
    
    func addDrop(to account: Account, csCase: CSCase) {
        account.cases[csCase, default: 0] += 1
        operations.append(Drop(account: account, caseDropped: csCase))
    }
    
    func saveTrade(from sender: Account, to receiver: Account, csCase: CSCase) {
        guard sender.id != receiver.id else { return }
        if let count = sender.cases[csCase], count > 0 {
            sender.cases[csCase]! -= 1
            receiver.cases[csCase, default: 0] += 1
            operations.append(Trade(sender: sender, receiver: receiver, caseTraded: csCase))
        }
    }
}
