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
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Trade")
            HStack {
                VStack {
                    Text("Sender")
                    Picker("Account 1", selection: $sender) {
                        ForEach(viewModel.accounts) { account in
                            Text(account.profileName)
                                .tag(account as Account?)
                        }
                    }
                }
                VStack {
                    Text("Receiver")
                    Picker("Account 2", selection: $receiver) {
                        ForEach(viewModel.accounts) { account in
                            Text(account.profileName)
                                .tag(account as Account?)
                        }
                    }
                }
            }
            ForEach(CSCase.allCases) { csCase in
                HStack {
                    Image(csCase.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                    Text(csCase.displayName)
                    Spacer()
                    TextField("0", text: binding(for: csCase))
                        .frame(width: 50)
                        .keyboardType(.numberPad)
                }
            }
            Button {
                guard let sender, let receiver, !cases.isEmpty else { return }
                viewModel.saveTrade(from: sender, to: receiver, cases: cases)
                dismiss()
            } label: {
                Text("Save")
            }
        }
    }
    
    private func binding(for key: CSCase) -> Binding<String> {
        Binding<String>(
            get: {
                String(cases[key] ?? 0)
            },
            set: { newValue in
                cases[key] = Int(newValue) ?? 0
            }
        )
    }
}
