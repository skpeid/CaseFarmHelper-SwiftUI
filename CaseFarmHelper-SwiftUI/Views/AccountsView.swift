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
    @State var accounts: [Account] = [
        Account(profileName: "skpeid", username: "", cases: [.recoil:30, .fracture:20]),
        Account(profileName: "jks", username: "syrazavr", cases: [.revolution:40, .kilowatt:13]),
    ]
    
    var body: some View {
        NavigationStack {
            List(accounts) { account in
                NavigationLink(value: account) {
                    HStack {
                        Text(account.profileName)
                        Spacer()
                        Text("Cases: \(account.getCasesCount)")
                    }
                }
            }
            .navigationTitle("Accounts")
            .navigationDestination(isPresented: $isPresentedAddAccount, destination: {
                AddAccountView(accounts: $accounts)
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
