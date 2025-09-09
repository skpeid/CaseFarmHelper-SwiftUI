//
//  Extensions.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 29.08.2025.
//

import Foundation

extension String {
    func priceToDouble() -> Double? {
        var s = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.isEmpty { return nil }

        s = s.replacingOccurrences(of: "\u{00A0}", with: "")

        let allowed = CharacterSet(charactersIn: "0123456789.,-")
        s = String(s.unicodeScalars.filter { allowed.contains($0) })

        guard !s.isEmpty else { return nil }

        if s.contains(",") && s.contains(".") {
            if let lastDot = s.lastIndex(of: "."), let lastComma = s.lastIndex(of: ",") {
                if lastDot > lastComma {
                    s = s.replacingOccurrences(of: ",", with: "")
                } else {
                    s = s.replacingOccurrences(of: ".", with: "")
                    s = s.replacingOccurrences(of: ",", with: ".")
                }
            }
        } else if s.contains(",") {
            s = s.replacingOccurrences(of: ",", with: ".")
        }

        return Double(s)
    }
}

extension Dictionary {
    func mapKeys<T>(_ transform: (Key) -> T) -> [T: Value] {
        Dictionary<T, Value>(uniqueKeysWithValues: map { (transform($0.key), $0.value) })
    }
    
    func compactMapKeys<T>(_ transform: (Key) -> T?) -> [T: Value] {
        Dictionary<T, Value>(uniqueKeysWithValues: compactMap {
            guard let newKey = transform($0.key) else { return nil }
            return (newKey, $0.value)
        })
    }
}

extension FileManager {
    static var accountsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("accounts.json")
    }
}

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
    
    var weekOfYear: Int {
        Calendar.current.component(.weekOfYear, from: self)
    }
}
