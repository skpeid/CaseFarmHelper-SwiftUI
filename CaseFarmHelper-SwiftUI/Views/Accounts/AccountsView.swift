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
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: HStack {
                    Text("\(viewModel.accounts.count) accounts")
                    Spacer()
                    Text("Total cases: \(viewModel.getTotalCasesAmount)")
                }) {
                    List(viewModel.accounts) { account in
                        NavigationLink(value: account) {
                            AccountCellView(account: account)
                        }
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
                        .fontWeight(.semibold)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        PersistenceManager.shared.deleteAccountsFile()
                        viewModel.accounts.removeAll()
                    } label: {
                        Text("Delete all accounts")
                    }

                }
            }
        }
    }
}

struct AccountCellView: View {
    @ObservedObject var account: Account
    
    var body: some View {
        HStack {
            AccountAvatarView(image: account.profileImage, size: Constants.menuAvatarSize)
            VStack(alignment: .leading) {
                Text(account.profileName)
                    .fontWeight(.semibold)
                Text("@\(account.username)")
                    .font(.caption2)
            }
            .padding(.horizontal)
            Spacer()
            Text("Cases: \(account.getTotalCasesAmount)")
        }
    }
}
