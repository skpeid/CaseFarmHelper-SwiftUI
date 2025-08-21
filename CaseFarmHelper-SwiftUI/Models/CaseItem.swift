//
//  Case.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import Foundation

struct CaseItem {
    let caseType: CaseType
    var displayName: String {
        caseType.displayName
    }
    var imageName: String {
        caseType.rawValue
    }
}

enum CaseType: String {
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
}
