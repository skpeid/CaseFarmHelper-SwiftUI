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
    @State private var isPresentedImportAccounts: Bool = false
    @State private var accountToDelete: Account?
    @State private var showDeleteAlert = false
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: HStack {
                    Text("\(viewModel.accounts.count) accounts")
                    Spacer()
                    Text("Total cases: \(viewModel.getTotalCasesAmount)")
                }) {
                    List {
                        ForEach(viewModel.accounts) { account in
                            NavigationLink(value: account) {
                                AccountCellView(account: account)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            if let index = indexSet.first {
                                accountToDelete = viewModel.accounts[index]
                                showDeleteAlert = true
                            }
                        })
                    }
                    .alert("Delete Account", isPresented: $showDeleteAlert, presenting: accountToDelete) { account in
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            if let index = viewModel.accounts.firstIndex(where: { $0.id == account.id }) {
                                viewModel.accounts.remove(at: index)
                                viewModel.saveAccounts()
                            }
                        }
                    } message: { account in
                        Text("Are you sure you want to delete \(account.profileName)?")
                    }
                }
            }
            .navigationTitle("Accounts")
            .navigationDestination(isPresented: $isPresentedAddAccount, destination: {
                AddAccountView()
            })
            .navigationDestination(isPresented: $isPresentedImportAccounts, destination: {
                ImportAccountsView()
            })
            .navigationDestination(for: Account.self) { account in
                AccountDetailsView(account: account)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isPresentedImportAccounts.toggle()
                    } label: {
                        Text("Import")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentedAddAccount.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
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
