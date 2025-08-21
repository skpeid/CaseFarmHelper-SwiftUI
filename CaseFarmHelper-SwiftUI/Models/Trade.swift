//
//  Trade.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import Foundation

final class Trade: Operation {
    let sender: Account
    let receiver: Account
    let caseTraded: CSCase
    
    init(sender: Account, receiver: Account, caseTraded: CSCase) {
        self.sender = sender
        self.receiver = receiver
        self.caseTraded = caseTraded
    }
}
