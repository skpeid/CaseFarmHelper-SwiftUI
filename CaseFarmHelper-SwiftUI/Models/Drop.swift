//
//  Drop.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import Foundation

struct DropDTO: Codable, Identifiable {
    let id: UUID
    let date: Date
    let accountID: UUID
    let caseDropped: String
}

final class Drop: Operation {
    let account: Account
    let caseDropped: CSCase
    
    init(account: Account, caseDropped: CSCase, id: UUID = UUID(), date: Date) {
        self.account = account
        self.caseDropped = caseDropped
        super.init(id: id, date: date)
    }
}

extension Drop {
    func toDTO() -> DropDTO {
        DropDTO(
            id: id,
            date: date,
            accountID: account.id,
            caseDropped: caseDropped.rawValue
        )
    }
    
    static func fromDTO(_ dto: DropDTO, accounts: [Account]) -> Drop? {
        guard let account = accounts.first(where: { $0.id == dto.accountID }),
              let csCase = CSCase(rawValue: dto.caseDropped) else { return nil }
        let drop = Drop(account: account, caseDropped: csCase, date: dto.date)
        return drop
    }
}
