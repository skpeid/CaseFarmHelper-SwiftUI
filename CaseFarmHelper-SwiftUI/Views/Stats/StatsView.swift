//
//  StatsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @StateObject private var statsVM = StatsViewModel()
    @State private var isPresentedInventoryValue: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CasesTickerView(prices: statsVM.casePrices)
                VStack {
                    Text("Total Cases: \(statsVM.totalCases(from: appVM.accounts))")

                                Text("Total Value: \(statsVM.totalValue(from: appVM.accounts), specifier: "%.2f")")
                }
                Spacer()
                RoundedButton(title: "Get Value") {
                    isPresentedInventoryValue.toggle()
                }
                .padding()
//                .padding(.bottom)
                //                .navigationDestination(isPresented: $isPresentedInventoryValue) {
                //                    InventoryValueView()
                //                }
            }
        }
        .onAppear {
            Task {
                await statsVM.fetchAllCases()
            }
        }
    }
}
#Preview {
    StatsView()
}
