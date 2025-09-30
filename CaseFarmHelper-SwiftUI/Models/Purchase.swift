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
    let casePurchased: String
    let amount: Int
    let totalCost: Double
}

final class Purchase: Operation {
    let account: Account
    let casePurchased: CSCase
    let amount: Int
    let totalCost: Double
    
    var pricePerCase: Double {
        guard amount > 0 else { return 0 }
        return totalCost / Double(amount)
    }
    
    init(id: UUID = UUID(), date: Date, account: Account, caseBought: CSCase, amount: Int, totalCost: Double) {
        self.account = account
        self.casePurchased = caseBought
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
                    casePurchased: casePurchased.rawValue,
                    amount: amount,
                    totalCost: totalCost)
    }
    
    static func fromDTO(_ dto: PurchaseDTO, accounts: [Account]) -> Purchase? {
        guard let account = accounts.first(where: { $0.id == dto.accountID }),
              let csCase = CSCase(rawValue: dto.casePurchased) else { return nil }
        return Purchase(date: dto.date,
                        account: account,
                        caseBought: csCase,
                        amount: dto.amount,
                        totalCost: dto.totalCost)
    }
}
