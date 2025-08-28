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
        let dummyAcc4 = Account(profileName: "MAJORKA", username: "Ohnepixel", cases: [.recoil:100, .fracture:100, .dreamsAndNightmares: 100, .kilowatt: 100, .revolution: 100])
        accounts = [dummyAcc1, dummyAcc2, dummyAcc3, dummyAcc4]
        
        operations = [
            Drop(account: dummyAcc1, caseDropped: .dreamsAndNightmares),
            Trade(sender: dummyAcc2, receiver: dummyAcc1, casesTraded: [.recoil: 1]),
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
    
    func saveTrade(from sender: Account, to receiver: Account, cases: [CSCase: Int]) {
        if let senderIndex = accounts.firstIndex(where: { $0.id == sender.id }) {
            for (csCase, amount) in cases {
                accounts[senderIndex].cases[csCase, default: 0] -= amount
            }
        }
        
        if let receiverIndex = accounts.firstIndex(where: { $0.id == receiver.id }) {
            for (csCase, amount) in cases {
                accounts[receiverIndex].cases[csCase, default: 0] += amount
            }
        }
        
        let newTrade = Trade(sender: sender, receiver: receiver, casesTraded: cases)
        operations.append(newTrade)
    }
}
