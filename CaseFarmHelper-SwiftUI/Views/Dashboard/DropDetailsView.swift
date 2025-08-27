//
//  DropDetailsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 27.08.2025.
//

import SwiftUI

struct DropDetailsView: View {
    let drop: Drop
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Drop")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Account:")
            HStack {
                if let image = drop.account.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: Constants.detailsAvatarSize, height: Constants.detailsAvatarSize)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: Constants.detailsAvatarSize, height: Constants.detailsAvatarSize)
                        .overlay(Image(systemName: "person"))
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading) {
                    Text(drop.account.profileName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("@\(drop.account.username)")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            Text("has collected ") + Text(drop.caseDropped.displayName).fontWeight(.bold) + Text(" from weekly drop")
            VStack {
                Image(drop.caseDropped.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            }
            .frame(maxWidth: .infinity)
        }
        Text("Date and time: \(drop.formattedDate)")
    }
}

#Preview {
    DropDetailsView(drop: Drop(account: Account(profileName: "skpeid", username: "kingofgracious"), caseDropped: .dreamsAndNightmares))
}
