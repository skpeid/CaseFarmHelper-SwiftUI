//
//  StatsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @State private var isPresentedInventoryValue: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CasesTickerView(prices: viewModel.casePrices)
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
                await viewModel.fetchAllCases()
            }
        }
    }
}
#Preview {
    StatsView()
}
