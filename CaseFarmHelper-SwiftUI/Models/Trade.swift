//
//  Trade.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import Foundation

struct TradeDTO: Codable, Identifiable {
    let id: UUID
    let date: Date
    let senderID: UUID
    let receiverID: UUID
    let casesTraded: [String: Int]
}

final class Trade: Operation {
    let sender: Account
    let receiver: Account
    let casesTraded: [CSCase: Int]
    
    init(sender: Account, receiver: Account, casesTraded: [CSCase: Int], id: UUID = UUID(), date: Date) {
        self.sender = sender
        self.receiver = receiver
        self.casesTraded = casesTraded
        super.init(id: id, date: date)
    }
}

extension Trade {
    var isSingleCaseType: Bool {
        casesTraded.count == 1
    }
    
    var totalTraded: Int {
        casesTraded.values.reduce(0, +)
    }
}

extension Trade {
    func toDTO() -> TradeDTO {
        TradeDTO(
            id: id,
            date: date,
            senderID: sender.id,
            receiverID: receiver.id,
            casesTraded: casesTraded.mapKeys { $0.rawValue }
        )
    }
    
    static func fromDTO(_ dto: TradeDTO, accounts: [Account]) -> Trade? {
        guard let sender = accounts.first(where: { $0.id == dto.senderID }),
              let receiver = accounts.first(where: { $0.id == dto.receiverID }) else { return nil }
        
        let cases = dto.casesTraded.compactMapKeys { CSCase(rawValue: $0) }
        let trade = Trade(sender: sender, receiver: receiver, casesTraded: cases, date: dto.date)
        return trade
    }
}
