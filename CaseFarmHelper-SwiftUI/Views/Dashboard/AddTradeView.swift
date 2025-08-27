//
//  AddTradeView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AddTradeView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var sender: Account?
    @State var receiver: Account?
    @State var selectedCase: CSCase?
    
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
                    Text("Case")
                    Picker("Case", selection: $selectedCase) {
                        ForEach(CSCase.allCases) { csCase in
                            Text(csCase.displayName)
                                .tag(csCase as CSCase?)
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
            Button {
                guard let sender = sender, let selectedCase = selectedCase, let receiver = receiver else { return }
                viewModel.saveTrade(from: sender, to: receiver, csCase: selectedCase)
                dismiss()
            } label: {
                Text("Save")
            }
            
        }
    }
}
