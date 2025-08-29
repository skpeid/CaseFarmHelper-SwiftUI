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
                    }
//                    AccountAvatarView(image: sender?.profileImage, size: Constants.menuAvatarSize)
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
//                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 1)
                    )
                }
            }
//            ForEach(CSCase.allCases) { csCase in
//                HStack {
//                    Image(csCase.imageName)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 50)
//                    Text(csCase.displayName)
//                    Spacer()
//                    TextField("0", text: binding(for: csCase))
//                        .frame(width: 50)
//                        .keyboardType(.numberPad)
//                }
//            }
            Spacer()
            RoundedButton(title: "Save") {
                guard let sender, let receiver, !cases.isEmpty else { return }
                viewModel.saveTrade(from: sender, to: receiver, cases: cases)
                dismiss()
            }
            .navigationTitle("Trade")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
    }
    
    private func binding(for key: CSCase) -> Binding<Int> {
        Binding(
            get: { cases[key, default: 0] },
            set: { cases[key] = $0 }
            )
    }
//    private func binding(for key: CSCase) -> Binding<String> {
//        Binding<String>(
//            get: {
//                String(cases[key] ?? 0)
//            },
//            set: { newValue in
//                cases[key] = Int(newValue) ?? 0
//            }
//        )
//    }
}
