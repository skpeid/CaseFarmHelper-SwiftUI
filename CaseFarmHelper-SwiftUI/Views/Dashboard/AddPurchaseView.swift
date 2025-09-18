//
//  AddPurchaseView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 17.09.2025.
//

import SwiftUI

struct AddPurchaseView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedAccount: Account?
    @State private var selectedCase: CSCase?
    @State private var amount: String = ""
    @State private var cost: String = ""
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    VStack {
                        Text("Account")
                            .font(.headline)
                        Picker("", selection: $selectedAccount) {
                            Text("Select Account").foregroundStyle(.gray).tag(UUID?.none)
                            ForEach(viewModel.accounts) { account in
                                Text(account.profileName)
                                    .tag(Optional(account))
                            }
                        }
                        .border(Constants.purchaseColor, width: 2)
                    }
                }
                VStack {
                    Text("Case")
                        .font(.headline)
                    Picker("", selection: $selectedCase) {
                        Text("Select Case").foregroundStyle(.gray).tag(UUID?.none)
                        ForEach(CSCase.nonDropping, id: \.self) { csCase in
                            Text(csCase.displayName)
                                .tag(Optional(csCase))
                        }
                    }
                    .border(Constants.purchaseColor, width: 2)
                }
            }
            .padding()
            
            HStack {
                VStack {
                    Text("Quantity")
                        .font(.headline)
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal)
                Divider()
                VStack {
                    Text("Total Cost")
                        .font(.headline)
                    HStack {
                        TextField("0", text: $cost)
                            .keyboardType(.numberPad)
                        Text("₸")
                    }
                }
            }
            .padding()
            
            Spacer()
            
            if let amountInt = Int(amount),
               let totalCost = Double(cost),
               let selectedAccount,
               let selectedCase {
                RoundedButton(title: "Save") {
                    viewModel.performPurchase(account: selectedAccount,
                                              csCase: selectedCase,
                                              amount: amountInt,
                                              totalCost: totalCost)
                    dismiss()
                }
                .padding()
            }
        }
        .navigationTitle("Purchase")
        .navigationBarTitleDisplayMode(.inline)
    }
}
