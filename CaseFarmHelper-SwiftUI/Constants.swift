//
//  Constants.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct Constants {
    static let tickerWidth: CGFloat = 160
    static let tickerHeight: CGFloat = 60
    
    static let caseColumns = Array(repeating: GridItem(.flexible()), count: 3)
    static let accountColumns = Array(repeating: GridItem(.flexible()), count: 5)
    static let accountsProgressColumns = Array(repeating: GridItem(.flexible()), count: 7)
    
    static let menuAvatarSize: CGFloat = 48
    static let detailsAvatarSize: CGFloat = 82
    static let smallAvatarSize: CGFloat = 32
    static let dashboardCaseSize: CGFloat = 50
    static let bigCaseSize: CGFloat = 100
    
    //MARK: Colors
    static let tradeColor: Color = .indigo
    static let dropColor: Color = .green
}
