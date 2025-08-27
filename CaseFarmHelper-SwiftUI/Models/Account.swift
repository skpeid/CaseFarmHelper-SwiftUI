//
//  Account.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

final class Account: Identifiable, ObservableObject, Hashable {
    static func == (lhs: Account, rhs: Account) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    let id = UUID()
    @Published var profileName: String
    @Published var username: String
    @Published var cases: [CSCase: Int] = [:]
    @Published var profileImage: UIImage?
    
    init(profileName: String, username: String, cases: [CSCase : Int] = [:], profileImage: UIImage? = nil) {
        self.profileName = profileName
        self.username = username
        self.profileImage = profileImage
        //        var dict = [CSCase: Int]()
        //        for csCase in CSCase.allCases {
        //            dict[csCase] = cases[csCase] ?? 0
        //        }
        //        self.cases = dict
        self.cases = cases
    }
    
    var getTotalCasesAmount: Int {
        cases.values.reduce(0, +)
    }
}
