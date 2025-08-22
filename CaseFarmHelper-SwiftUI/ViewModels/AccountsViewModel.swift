//
//  AccountsViewModel.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

class AccountsViewModel: ObservableObject {
    
    @Published var accounts: [Account] = [
        Account(profileName: "skpeid", username: "", cases: [.recoil:30, .fracture:20]),
        Account(profileName: "jks", username: "syrazavr", cases: [.revolution:40, .kilowatt:13]),
        Account(profileName: "Observer Ward", username: "", cases: [.recoil:1, .fracture:2, .dreamsAndNightmares: 10, .kilowatt: 20, .revolution: 30]),
    ]
    
    func addAccount(_ account: Account) {
        accounts.append(account)
    }
    
    func removeAccount(at offsets: IndexSet) {
        accounts.remove(atOffsets: offsets)
    }
}
