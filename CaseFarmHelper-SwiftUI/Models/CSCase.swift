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
            return "Dreams and Nigthmares"
        case .recoil:
            return "Recoil"
        case .revolution:
            return "Revolution"
        case .fracture:
            return "Fracture"
        case .kilowatt:
            return "Kilowatt"
        }
    }
    
    var imageName: String { rawValue }
}
