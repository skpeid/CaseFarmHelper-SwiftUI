//
//  PurchasesInfoView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 18.09.2025.
//

import SwiftUI

struct PurchasesInfoView: View {
    let purchases: [Purchase]
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            ModalSheetHeaderView(title: "Purchases")
                .padding()
            Picker("View Mode", selection: $selectedTab) {
                Text("Summary").tag(0)
                Text("History").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            if selectedTab == 1 {
                List {
                    ForEach(purchases) { purchase in
                        Section(header: Text(purchase.monthDayString)) {
                            HStack {
                                VStack {
                                    Image(purchase.casePurchased.imageName)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text("x\(purchase.amount)").font(.headline)
                                }
                                VStack(alignment: .leading) {
                                    Text(purchase.account.profileName)
                                    Spacer()
                                    Text("Price: \(Int(purchase.pricePerCase))₸")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                Spacer()
                                VStack {
                                    Text("Total cost:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("\(Int(purchase.totalCost))₸").font(.headline)
                                }
                            }
                        }
                    }
                }
            } else {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Purchased cases")
                            .fontWeight(.semibold)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(CSCase.nonDropping, id: \.self) { csCase in
                                    let totalPurchased = purchases.filter { $0.casePurchased == csCase }
                                        .map(\.amount)
                                        .reduce(0, +)
                                    if totalPurchased > 0 {
                                        VStack(spacing: 8) {
                                            Image(csCase.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                            Text(csCase.displayName)
                                                .font(.caption)
                                                .bold()
                                                .lineLimit(1)
                                            Text("x\(totalPurchased)")
                                                .bold()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                    }
                    Divider()
                    VStack {
                        HStack {
                            Text("Total Spent")
                                .fontWeight(.semibold)
                                .padding(.top)
                            Spacer()
                            Text("Current Value")
                                .fontWeight(.semibold)
                                .padding(.top)
                        }
                        HStack {
                            Text("-40 000T")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(Constants.purchaseColor)
                            Divider()
                            Text("38 500T")
                                .font(.largeTitle)
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        Spacer().frame(height: 50)
                    }
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Profit")
                            .fontWeight(.semibold)
                            .padding(.top)
                        HStack {
                            Text("+3 205T")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(.green)
                            Divider()
                            Text("+18.05%")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(.green)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        Spacer().frame(height: 50)
                    }
                    Divider()
                    Spacer()
                }
                .padding()
            }
        }
    }
}
