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
            ModalSheetHeaderView(title: "Drop")
            HStack {
                AccountAvatarView(image: drop.account.profileImage, size: Constants.detailsAvatarSize)
                VStack(alignment: .leading) {
                    Text(drop.account.profileName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("@\(drop.account.username)")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            HStack {
                Text("has collected ") + Text(drop.caseDropped.displayName).fontWeight(.bold)
                Spacer()
                Image(drop.caseDropped.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.trailing)
            }
            Spacer()
            Divider()
            VStack(alignment: .center) {
                Text("Date and time: ") + Text(drop.fullDateString).fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding()
    }
}
