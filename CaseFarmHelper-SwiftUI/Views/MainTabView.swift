//
//  MainTabView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        TabView {
            DashboardView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash")
                }
            AccountsView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Accounts", systemImage: "person.3")
                }
            StatsView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

#Preview {
    MainTabView()
}
