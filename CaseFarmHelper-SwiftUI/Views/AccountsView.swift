//
//  ContentView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AccountsView: View {
    
    @State private var isPresentedAddAccount: Bool = false
    @State var accounts: [Account] = [
        
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(accounts) { account in
                    Button {
                        
                    } label: {
                        HStack {
                            Text(account.profileName)
                            Spacer()
                            Text("Cases: \(account.getCasesCount)")
                        }
                    }
                }
            }
            .navigationTitle("Accounts")
            .navigationDestination(isPresented: $isPresentedAddAccount, destination: {
                AddAccountView(accounts: $accounts)
            })
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
