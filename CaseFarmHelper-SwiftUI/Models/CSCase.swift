//
//  Case.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import Foundation

enum CSCase: String, CaseIterable, Identifiable, Hashable {
    var id: Self { self }
    
    case dreamsAndNightmares
    case recoil
    case revolution
    case fracture
    case kilowatt
    
    var displayName: String {
        switch self {
        case .dreamsAndNightmares:
            return "Dreams & Nigthmares Case"
        case .recoil:
            return "Recoil Case"
        case .revolution:
            return "Revolution Case"
        case .fracture:
            return "Fracture Case"
        case .kilowatt:
            return "Kilowatt Case"
        }
    }
    
    var marketHashName: String {
        displayName
    }
    
    var imageName: String { rawValue }
}
