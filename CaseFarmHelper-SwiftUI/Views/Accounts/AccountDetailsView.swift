//
//  AccountDetailsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AccountDetailsView: View {
    @State private var profileName: String = ""
    let account: Account
    
    var body: some View {
        Form {
            Section(header: Text("Account Info")) {
                HStack(alignment: .center) {
                    VStack {
                        if let image = account.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color(.systemGray4))
                                .frame(width: 100, height: 100)
                                .overlay(Image(systemName: "person.fill"))
                                .font(.system(size: 28))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("Profile Name")
                        Text(account.profileName).fontWeight(.semibold)
                        Divider()
                        Text("Username")
                        Text("@\(account.username)").fontWeight(.semibold)
                    }
                    .padding(.leading)
                }
            }
            if !account.cases.isEmpty {
                Section(header: HStack {
                    Text("Current Cases")
                    Spacer()
                    Text("Total: \(account.getTotalCasesAmount)").fontWeight(.semibold).foregroundStyle(.black)
                }) {
                    LazyVGrid(columns: Constants.caseColumns) {
                        ForEach(account.cases.sorted(by: { $0.key.rawValue < $1.key.rawValue }),
                                id: \.key) { csCase, amount in
                            VStack {
                                Image(csCase.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 90)
                                Text(csCase.displayName)
                                    .font(.caption)
                                Text("x\(amount)")
                                    .font(.caption2)
                            }
                        }
                    }
                }
            }
        }
    }
}
