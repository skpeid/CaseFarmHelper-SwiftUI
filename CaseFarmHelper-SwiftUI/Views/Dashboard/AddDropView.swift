//
//  AddDropView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AddDropView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var selectedAccount: Account?
    @State var selectedCase: CSCase?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Add Drop")
            HStack {
                VStack {
                    Text("Choose Account")
                    Picker("Account", selection: $selectedAccount) {
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
                
            }
            Button {
                guard let selectedAccount = selectedAccount, let selectedCase = selectedCase else { return }
                viewModel.addDrop(to: selectedAccount, csCase: selectedCase)
                dismiss()
            } label: {
                Text("Save")
            }

        }
    }
}
