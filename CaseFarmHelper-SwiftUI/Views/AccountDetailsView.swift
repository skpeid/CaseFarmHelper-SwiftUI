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
            Text(account.profileName)
            Text("@\(account.username)")
        }
    }
}

#Preview {
    AccountDetailsView(account: Account(profileName: "jks", username: "sks", cases: [.recoil:666]))
}
