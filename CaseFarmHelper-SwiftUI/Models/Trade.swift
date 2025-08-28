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
    let casesTraded: [CSCase: Int]
    
    init(sender: Account, receiver: Account, casesTraded: [CSCase: Int]) {
        self.sender = sender
        self.receiver = receiver
        self.casesTraded = casesTraded
    }
}
