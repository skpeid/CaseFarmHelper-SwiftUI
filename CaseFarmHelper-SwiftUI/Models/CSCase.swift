//
//  Case.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import Foundation

enum CSCase: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case dreamsAndNightmares
    case recoil
    case revolution
    case fracture
    case kilowatt
    
    var displayName: String {
        switch self {
        case .dreamsAndNightmares:
            return "Dreams and Nigthmares Case"
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
    
    var imageName: String { rawValue }
}
