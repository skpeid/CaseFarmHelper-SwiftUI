//
//  Account.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AccountDTO: Codable, Identifiable {
    let id: UUID
    var profileName: String
    var username: String
    var cases: [String: Int]
    var profileImage: Data?
    var lastDropDate: Date?
}

final class Account: Identifiable, ObservableObject, Hashable {
    static func == (lhs: Account, rhs: Account) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    let id: UUID
    @Published var profileName: String
    @Published var username: String
    @Published var cases: [CSCase: Int] = [:]
    @Published var profileImage: UIImage?
    var gotDropThisWeek: Bool {
        guard let lastDropDate else { return false }
        return lastDropDate >= Date.lastResetDate
    }
    @Published var lastDropDate: Date?
    
    init(id: UUID = UUID(), profileName: String, username: String, cases: [CSCase : Int] = [:], profileImage: UIImage? = nil, lastDropDate: Date? = nil) {
        self.id = id
        self.profileName = profileName
        self.username = username
        self.profileImage = profileImage
        self.cases = cases
        self.lastDropDate = lastDropDate
    }
    
    var getTotalCasesAmount: Int {
        cases.values.reduce(0, +)
    }
}

extension Account {
    func toDTO() -> AccountDTO {
        AccountDTO(id: id,
                   profileName: profileName,
                   username: username,
                   cases: cases.mapKeys { $0.rawValue },
                   lastDropDate: lastDropDate
        )
    }
    
    static func fromDTO(_ dto: AccountDTO) -> Account {
        let account = Account(id: dto.id,
                              profileName: dto.profileName,
                              username: dto.username,
                              cases: dto.cases.compactMapKeys { CSCase(rawValue: $0) },
                              lastDropDate: dto.lastDropDate
            )
        return account
    }
}
