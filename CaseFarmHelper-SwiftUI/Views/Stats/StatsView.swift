//
//  StatsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

struct StatsView: View {
//    @StateObject private var viewModel = StatsViewModel()
    @State private var isPresentedInventoryValue: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                RoundedButton(title: "Get Value") {
                    isPresentedInventoryValue.toggle()
                }
                .padding()
                .navigationTitle("Stats")
                .navigationDestination(isPresented: $isPresentedInventoryValue) {
                    InventoryValueView()
                }
            }
        }
    }
}
#Preview {
    StatsView()
}
