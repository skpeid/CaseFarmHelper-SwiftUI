//
//  StatsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @EnvironmentObject var statsVM: StatsViewModel
    @State private var isPresentedDropsInfoView: Bool = false
    @State private var isPresentedInventoryView: Bool = false
    @State private var isPresentedPurchasesInfoView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CasesTickerView(prices: statsVM.casePrices)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Inventory Value")
                        Spacer()
                        Text("from \(appVM.getTotalCasesAmount) cases")
                    }
                    HStack {
                        Spacer()
                        Text("\(statsVM.totalValue(from: appVM.accounts), specifier: "%.2f")₸")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.green)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 50)
                VStack {
                    HStack {
                        InfoCircleView(title: "Inventory", value: "\(appVM.getTotalCasesAmount)")
                            .padding(.trailing, 30)
                            .onTapGesture {
                                isPresentedInventoryView.toggle()
                            }
                        InfoCircleView(title: "Drops", value: "\(appVM.drops.count)")
                            .padding(.trailing, 30)
                            .onTapGesture {
                                isPresentedDropsInfoView.toggle()
                            }
                        InfoCircleView(title: "Purchases", value: "\(appVM.purchases.count)")
                            .onTapGesture {
                                isPresentedPurchasesInfoView.toggle()
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
                await statsVM.fetchCase(for: appVM.tickerCases)
            }
        }
        .sheet(isPresented: $isPresentedInventoryView) {
            InventoryView()
        }
        .sheet(isPresented: $isPresentedDropsInfoView) {
            DropsInfoView(drops: appVM.drops)
        }
        .sheet(isPresented: $isPresentedPurchasesInfoView) {
            PurchasesInfoView()
        }
    }
}
