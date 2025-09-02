//
//  AddTradeView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AddTradeView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var sender: Account?
    @State private var receiver: Account?
    @State private var cases: [CSCase: Int] = [:]
    @State private var alertMessage: String?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    VStack {
                        Text("From")
                            .font(.headline)
                        Picker("", selection: $sender) {
                            Text("Select Sender").foregroundStyle(.gray).tag(Optional<Account>(nil))
                            ForEach(viewModel.accounts) { account in
                                Text(account.profileName)
                                    .tag(account as Account?)
                            }
                        }
                        .border(.indigo, width: 2)
                    }
                }
                VStack {
                    Text("To")
                        .font(.headline)
                    Picker("", selection: $receiver) {
                        Text("Select Receiver").foregroundStyle(.gray).tag(Optional<Account>(nil))
                        ForEach(viewModel.accounts) { account in
                            Text(account.profileName)
                                .tag(account as Account?)
                        }
                    }
                }
            }
            .padding()
            Divider()
            LazyVGrid(columns: Constants.caseColumns) {
                ForEach(CSCase.allCases) { csCase in
                    VStack {
                        Image(csCase.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.bigCaseSize)
                        Text(csCase.displayName)
                            .font(.caption)
                        Stepper(value: binding(for: csCase), in: 0...99) {
                            Text("\(cases[csCase, default: 0])")
                                .frame(width: 30)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 1)
                    )
                }
            }
            Spacer()
            RoundedButton(title: "Save") {
                saveTrade()
            }
            .navigationTitle("Trade")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
        .alert("Trade Error", isPresented: Binding(get: {alertMessage != nil }, set: { if !$0 { alertMessage = nil } })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage ?? "")
        }
        .onChange(of: sender?.id) { _ in limitAllToAvailable() }
    }
    
    private func available(for csCase: CSCase) -> Int {
        sender?.cases[csCase, default: 0] ?? 0
    }
    
    private func binding(for csCase: CSCase) -> Binding<Int> {
        Binding {
            cases[csCase, default: 0]
        } set: { newValue in
            let maxValue = available(for: csCase)
            cases[csCase] = max(0, min(newValue, maxValue))
        }
    }
    
    private var canSave: Bool {
        guard let from = sender, let to = receiver, from.id != to.id else { return false }
        let filtered = cases.filter { $0.value > 0 }
        guard !filtered.isEmpty else { return false }
        
        for (csCase, amount) in filtered {
            if amount > available(for: csCase) {
                return false
            }
        }
        return true
    }
    
    private func limitAllToAvailable() {
        for csCase in CSCase.allCases {
            let maxValue = available(for: csCase)
            if let amount = cases[csCase], amount > maxValue {
                cases[csCase] = maxValue
            }
        }
    }
    
    private func saveTrade() {
        guard let from = sender, let to = receiver else { return }
        let filteredCases = cases.filter { $0.value > 0 }
        if let error = viewModel.validateTrade(from: from, to: to, cases: filteredCases) {
            alertMessage = error.localizedDescription
            return
        }
        do {
            try viewModel.performTrade(from: from, to: to, cases: filteredCases)
            viewModel.operations.append(Trade(sender: from, receiver: to, casesTraded: cases))
            cases.removeAll()
            dismiss()
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
