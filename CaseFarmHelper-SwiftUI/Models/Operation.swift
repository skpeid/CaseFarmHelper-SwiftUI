//
//  Operation.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import Foundation

class Operation: Identifiable {
    let id: UUID
    let date: Date
    
    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
    }
    
    var fullDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy, H:mm"
        return formatter.string(from: date)
    }
    
    var monthDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter.string(from: date)
    }
}
