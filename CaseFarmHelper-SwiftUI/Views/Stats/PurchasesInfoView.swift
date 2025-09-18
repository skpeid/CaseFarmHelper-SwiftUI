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
                
            }
        }
    }
}
