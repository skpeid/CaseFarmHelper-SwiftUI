//
//  MainTabView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var appVM = AppViewModel()
    @StateObject private var statsVM = StatsViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .environmentObject(appVM)
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash")
                }
                .tag(0)
            AccountsView()
                .environmentObject(appVM)
                .tabItem {
                    Label("Accounts", systemImage: "person.3")
                }
                .tag(1)
            StatsView()
                .environmentObject(appVM)
                .environmentObject(statsVM)
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabView()
}
