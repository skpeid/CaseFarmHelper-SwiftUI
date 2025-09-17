//
//  Purchase.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 17.09.2025.
//

import Foundation

struct PurchaseDTO: Codable, Identifiable {
    let id: UUID
    let date: Date
    let accountID: UUID
    let caseBought: String
    let amount: Int
    let totalCost: Double
    
}

final class Purchase: Operation {
    let account: Account
    let caseBought: CSCase
    let amount: Int
    let totalCost: Double
    
    var pricePerCase: Double {
        guard amount > 0 else { return 0 }
        return totalCost / Double(amount)
    }
    
    init(id: UUID = UUID(), date: Date, account: Account, caseBought: CSCase, amount: Int, totalCost: Double) {
        self.account = account
        self.caseBought = caseBought
        self.amount = amount
        self.totalCost = totalCost
        super.init(id: id, date: date)
    }
}

extension Purchase {
    func toDTO() -> PurchaseDTO {
        PurchaseDTO(id: id,
                    date: date,
                    accountID: account.id,
                    caseBought: caseBought.rawValue,
                    amount: amount,
                    totalCost: totalCost)
    }
    
    func fromDTO(_ dto: PurchaseDTO, accounts: [Account]) -> Purchase? {
        guard let account = accounts.first(where: { $0.id == dto.accountID }),
              let csCase = CSCase(rawValue: dto.caseBought) else { return nil }
        return Purchase(date: dto.date,
                        account: account,
                        caseBought: csCase,
                        amount: dto.amount,
                        totalCost: dto.totalCost)
    }
}
