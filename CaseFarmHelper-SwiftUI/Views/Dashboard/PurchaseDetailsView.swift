//
//  PurchaseDetailsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 18.09.2025.
//

import SwiftUI

struct PurchaseDetailsView: View {
    let purchase: Purchase
    
    var body: some View {
        VStack(alignment: .leading) {
            ModalSheetHeaderView(title: "Purchase")
            HStack {
                AccountAvatarView(image: purchase.account.profileImage, size: Constants.detailsAvatarSize)
                VStack(alignment: .leading) {
                    Text(purchase.account.profileName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("@\(purchase.account.username)")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("purchased ") + Text("\(purchase.amount) \(purchase.casePurchased.displayName)s").fontWeight(.bold)
                    Text("for ") + Text("\(Int(purchase.totalCost))₸").fontWeight(.bold)
                    Divider()
                    Text("Price: ") + Text("\(Int(purchase.pricePerCase))₸").fontWeight(.bold)
                }
                Spacer()
                Image(purchase.casePurchased.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.trailing)
            }
            Spacer()
            Divider()
            VStack(alignment: .center) {
                Text("Date and time: ") + Text(purchase.fullDateString).fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding()
    }
}
