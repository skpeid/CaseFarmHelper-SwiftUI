//
//  AccountDetailsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AccountDetailsView: View {
    let account: Account
    
    var body: some View {
        VStack {
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
            }
            Text(account.profileName)
            Text("@\(account.username)")
            if account.cases.isEmpty {
                Text("No cases")
            } else {
                LazyVGrid(columns: Constants.columns) {
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
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AccountDetailsView(account: Account(profileName: "jks", username: "sks", cases: [.recoil:666]))
}
