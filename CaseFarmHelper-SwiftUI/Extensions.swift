//
//  Extensions.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 29.08.2025.
//

import Foundation

extension Date {
    static var lastResetDate: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        
        components.weekday = 4
        components.hour = 6
        components.minute = 0
        components.second = 0
        
        let thisWeek = calendar.date(from: components)!
        if thisWeek > Date() {
            return calendar.date(byAdding: .day, value: -7, to: thisWeek)!
        }
        return thisWeek
    }
}
