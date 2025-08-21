//
//  Drop.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import Foundation

final class Drop: Operation {
    let account: Account
    let caseDropped: CSCase
    
    init(account: Account, caseDropped: CSCase) {
        self.account = account
        self.caseDropped = caseDropped
    }
}
