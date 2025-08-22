//
//  CaseFarmHelper_SwiftUIApp.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

@main
struct CaseFarmHelper_SwiftUIApp: App {
    
    @StateObject var accountsViewModel = AccountsViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(accountsViewModel)
        }
    }
}
