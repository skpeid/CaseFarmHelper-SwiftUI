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
    @State private var isPresentedDropsHistoryView: Bool = false
    @State private var isPresentedInventoryView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CasesTickerView(prices: statsVM.casePrices)
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
                VStack {
                    HStack {
                        InfoCircleView(title: "Inventory", value: "\(appVM.getTotalCasesAmount)")
                            .padding(.trailing, 30)
                            .onTapGesture {
                                isPresentedInventoryView.toggle()
                            }
                        InfoCircleView(title: "Drops", value: "\(appVM.drops.count)")
                            .onTapGesture {
                                isPresentedDropsHistoryView.toggle()
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
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
        .sheet(isPresented: $isPresentedInventoryView) {
            InventoryView()
        }
        .sheet(isPresented: $isPresentedDropsHistoryView) {
            DropsHistoryView(drops: appVM.drops)
        }
    }
}
#Preview {
    StatsView()
}
