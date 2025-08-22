//
//  MainTabView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var accountsViewModel: AccountsViewModel
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash")
                }
            AccountsView()
                .tabItem {
                    Label("Accounts", systemImage: "person.3")
                }
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

#Preview {
    MainTabView()
}
