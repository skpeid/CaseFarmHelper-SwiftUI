//
//  AddTradeView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AddTradeView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var senderID: UUID?
    @State private var receiverID: UUID?
    @State private var cases: [CSCase: Int] = [:]
    @State private var alertMessage: String?
    
    private var sender: Account? {
        viewModel.accounts.first { $0.id == senderID }
    }
    private var receiver: Account? {
        viewModel.accounts.first { $0.id == receiverID }
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    HStack {
                        VStack {
                            Text("From")
                                .font(.headline)
                            Picker("", selection: $senderID) {
                                Text("Select Sender").foregroundStyle(.gray).tag(UUID?.none)
                                ForEach(viewModel.accounts) { account in
                                    Text(account.profileName)
                                        .tag(Optional(account.id))
                                }
                            }
                            .border(Constants.tradeColor, width: 2)
                        }
                    }
                    VStack {
                        Text("To")
                            .font(.headline)
                        Picker("", selection: $receiverID) {
                            Text("Select Receiver").foregroundStyle(.gray).tag(UUID?.none)
                            ForEach(viewModel.accounts) { account in
                                Text(account.profileName)
                                    .tag(Optional(account.id))
                            }
                        }
                        .border(Constants.tradeColor, width: 2)
                    }
                }
                .padding()
                Divider()
                if let sender = sender {
                    LazyVGrid(columns: Constants.caseColumns) {
                        ForEach(Array(sender.cases.keys)) { csCase in
                            VStack {
                                Image(csCase.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Constants.bigCaseSize)
                                Text(csCase.displayName)
                                    .font(.caption)
                                    .lineLimit(1)
                                Stepper(value: binding(for: csCase), in: 0...99) {
                                    Text("\(cases[csCase, default: 0])")
                                        .frame(width: 30)
                                }
                                .padding(.bottom)
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Trade")
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
            if let sender = sender {
                Button("Select All Cases (\(sender.getTotalCasesAmount))") {
                    selectAllCases(for: sender)
                }
                .padding(.vertical)
            }
            RoundedButton(title: "Save") {
                saveTrade()
            }
        }
        .onChange(of: senderID) { newValue in
            cases.removeAll()
            if let newSender = viewModel.accounts.first(where: { $0.id == newValue }) {
                for (csCase, _) in newSender.cases {
                    cases[csCase] = 0
                }
            }
        }
        .padding()
        .alert("Trade Error", isPresented: Binding(get: {alertMessage != nil }, set: { if !$0 { alertMessage = nil } })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage ?? "")
        }
    }
    
    private func binding(for csCase: CSCase) -> Binding<Int> {
        Binding {
            cases[csCase, default: 0]
        } set: { newValue in
            let maxValue = sender?.cases[csCase] ?? 0
            cases[csCase] = max(0, min(newValue, maxValue))
        }
    }
    
    private func selectAllCases(for sender: Account) {
        for (csCase, amount) in sender.cases {
            cases[csCase] = amount
        }
    }
    
    private func saveTrade() {
        do {
            let (from, to, filtered) = try viewModel.validateTrade(sender: sender, receiver: receiver, cases: cases)
            try viewModel.performTrade(from: from, to: to, cases: filtered)
            dismiss()
        } catch {
            alertMessage = error.localizedDescription
        }
    }
    
}
