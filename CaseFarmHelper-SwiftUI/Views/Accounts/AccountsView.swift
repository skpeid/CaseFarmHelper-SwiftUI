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
            List(viewModel.accounts) { account in
                NavigationLink(value: account) {
                    AccountCellView(account: account)
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

struct AccountCellView: View {
    let account: Account
    
    var body: some View {
        HStack {
            if let image = account.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                    .overlay(Image(systemName: "person"))
                    .foregroundStyle(.white)
            }
            Text(account.profileName)
                .padding()
            Spacer()
            Text("Cases: \(account.getTotalCasesAmount)")
        }
    }
}
