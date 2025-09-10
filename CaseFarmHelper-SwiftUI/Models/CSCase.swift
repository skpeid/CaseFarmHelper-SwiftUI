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
    //    case bravo
    //    case breakout
    //    case brokenFang
    //    case chroma
    //    case chroma2
    //    case chroma3
    
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
            //        case .bravo:
            //            return "Operation Bravo Case"
            //        case .breakout:
            //            return "Operation Breakout Weapon Case"
            //        case .brokenFang:
            //            return "Operation Broken Fang Case"
            //        case .chroma:
            //            return "Chroma Case"
            //        case .chroma2:
            //            return "Chroma 2 Case"
            //        case .chroma3:
            //            return "Chroma 3 Case"
        }
    }
    
    var tickerName: String {
        switch self {
        case .dreamsAndNightmares:
            return "D&N"
        case .recoil:
            return "RCOIL"
        case .revolution:
            return "REVO"
        case .fracture:
            return "FRAC"
        case .kilowatt:
            return "KWATT"
        }
    }
    
    var marketHashName: String {
        if self != .dreamsAndNightmares {
            return displayName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? displayName
        } else {
            return "Dreams%20%26%20Nightmares%20Case"
        }
    }
    
    var imageName: String { rawValue }
}
