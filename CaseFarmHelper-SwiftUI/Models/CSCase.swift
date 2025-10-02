//
//  Case.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

enum CSCase: String, CaseIterable, Identifiable, Hashable {
    var id: Self { self }
    
    // Active drop cases
    case dreamsAndNightmares
    case recoil
    case revolution
    case kilowatt
    case sealedGenesisTerminal
    
    // Rare drop cases
    case bravo
    case breakout
    case brokenFang
    case chroma
    case chroma2
    case chroma3
    case prisma
    case prisma2
    case shadow
    case spectrum
    case spectrum2
    
    // Non-dropping cases
    case fracture
    case gallery
    case fever
    
    static let activeDrop: [CSCase] = [.dreamsAndNightmares, .recoil, .revolution, .kilowatt, .sealedGenesisTerminal]
    static let rareDrop: [CSCase] = [.bravo, .breakout, .brokenFang, .chroma, .chroma2, .chroma3, .prisma, .prisma2, .shadow, .spectrum, .spectrum2]
    static let nonDropping: [CSCase] = [.fracture, .gallery, .fever]
    
    var displayName: String {
        switch self {
        case .dreamsAndNightmares: return "Dreams & Nigthmares Case"
        case .recoil: return "Recoil Case"
        case .revolution: return "Revolution Case"
        case .fracture: return "Fracture Case"
        case .kilowatt: return "Kilowatt Case"
        case .bravo: return "Operation Bravo Case"
        case .breakout: return "Operation Breakout Weapon Case"
        case .brokenFang: return "Operation Broken Fang Case"
        case .chroma: return "Chroma Case"
        case .chroma2: return "Chroma 2 Case"
        case .chroma3: return "Chroma 3 Case"
        case .gallery: return "Gallery Case"
        case .fever: return "Fever Case"
        case .prisma: return "Prisma Case"
        case .prisma2: return "Prisma 2 Case"
        case .shadow: return "Shadow Case"
        case .spectrum: return "Spectrum Case"
        case .spectrum2: return "Spectrum 2 Case"
        case .sealedGenesisTerminal: return "Sealed Genesis Terminal"
        }
    }
    
    var tickerName: String {
        switch self {
        case .dreamsAndNightmares: return "D&N"
        case .recoil: return "RCOIL"
        case .revolution: return "REVO"
        case .fracture: return "FRAC"
        case .kilowatt: return "KWATT"
        case .bravo: return "BRAV"
        case .breakout: return "BRKUT"
        case .brokenFang: return "BR-FG"
        case .chroma: return "CHR-1"
        case .chroma2: return "CHR-2"
        case .chroma3: return "CHR-3"
        case .gallery: return "GALR"
        case .fever: return "FVR"
        case .prisma: return "PRS-1"
        case .prisma2: return "PRS-2"
        case .shadow: return "SHADW"
        case .spectrum: return "SPC-1"
        case .spectrum2: return "SPC-2"
        case .sealedGenesisTerminal: return "TERMN"
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
