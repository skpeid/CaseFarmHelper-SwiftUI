//
//  Account.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import Foundation

struct Account: Identifiable {
    let id = UUID()
    let profileName: String
    let username: String
    var cases: [CSCase: Int] = [:]
    
    var getCasesCount: Int {
        cases.values.reduce(0, +)
    }
}
