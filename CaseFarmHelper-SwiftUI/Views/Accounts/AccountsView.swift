//
//  ContentView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AccountsView: View {
    
    @State private var isPresentedAddAccount: Bool = false
    @State private var isPresentedAccountDetails: Bool = false
    
    @EnvironmentObject var accountsViewModel: AccountsViewModel
    
    var body: some View {
        NavigationStack {
            List(accountsViewModel.accounts) { account in
                NavigationLink(value: account) {
                    HStack {
                        Text(account.profileName)
                        Spacer()
                        Text("Cases: \(account.getTotalCasesAmount)")
                    }
                }
            }
            .navigationTitle("Accounts")
            .navigationDestination(isPresented: $isPresentedAddAccount, destination: {
                AddAccountView()
            })
            .navigationDestination(for: Account.self) { account in
                AccountDetailsView(account: account)
            }
            .toolbar {
                Button {
                    isPresentedAddAccount.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
    }
}

#Preview {
    AccountsView()
}
