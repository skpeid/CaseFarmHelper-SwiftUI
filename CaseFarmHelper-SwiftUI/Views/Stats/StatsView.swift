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
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Inventory Value:")
                    HStack {
                        Spacer()
                        Text("\(statsVM.totalValue(from: appVM.accounts), specifier: "%.2f")₸")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.green)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("from \(appVM.getTotalCasesAmount) cases")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                Spacer()
                Text("Full statistics is being developed")
                    .font(.footnote)
                    .padding()
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
