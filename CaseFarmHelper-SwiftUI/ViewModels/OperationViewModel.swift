//
//  OperationViewModel.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

class OperationViewModel: ObservableObject {
    
    @Published var operations: [Operation] = [
        Drop(account: Account(profileName: "jks", username: ""), caseDropped: .dreamsAndNightmares),
        Trade(sender: Account(profileName: "skpeid", username: ""), receiver: Account(profileName: "ObserWard", username: ""), caseTraded: .recoil),
        Drop(account: Account(profileName: "jks", username: ""), caseDropped: .fracture)
    ]
    
    func addDrop(_ drop: Drop) {
        operations.append(drop)
    }
    
    func saveTrade(_ trade: Trade) {
//        let tradedCase = trade.caseTraded
        operations.append(trade)
    }
}
