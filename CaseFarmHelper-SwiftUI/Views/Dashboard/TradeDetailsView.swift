//
//  TradeDetailsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 28.08.2025.
//

import SwiftUI

struct TradeDetailsView: View {
    let trade: Trade
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Trade")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "multiply")
                        .foregroundStyle(.black)
                        .font(.system(size: 24))
                }
            }
            HStack {
                if let image = trade.receiver.profileImage {
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
                    Text(trade.receiver.profileName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("@\(trade.receiver.username)")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            if trade.isSingleCaseType {
                if let (csCase, amount) = trade.casesTraded.first {
                    HStack {
                        Text("has received ") + Text("\(amount) \(csCase.displayName)(-s)").fontWeight(.bold) + Text(" from: ") + Text(trade.sender.profileName).fontWeight(.bold)
                        Spacer()
                        Image(csCase.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding(.trailing)
                    }
                    .padding()
                }
            } else {
                let sortedCases = trade.casesTraded.sorted { $0.value > $1.value }
                VStack(alignment: .leading) {
                    Text("has received") + Text(" \(trade.totalTraded) cases").fontWeight(.bold) + Text(" from ") + Text(trade.sender.profileName).fontWeight(.bold)
                    LazyVGrid(columns: Constants.columns) {
                        ForEach(Array(sortedCases), id: \.key) { csCase, amount in
                            VStack {
                                Image(csCase.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                Spacer(minLength: 4)
                                Text(csCase.displayName)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                Text("x\(amount)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
            }
            Spacer()
            Divider()
            VStack(alignment: .center) {
                Text("Date and time: ") + Text(trade.fullDateString).fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    TradeDetailsView(trade: Trade(sender: Account(profileName: "MAJORKA", username: "Ohnepixel"), receiver: Account(profileName: "emptyACC", username: "hduiahsiu"), casesTraded: [.recoil:101, .fracture:102, .dreamsAndNightmares: 100, .kilowatt: 99, .revolution: 98]))
}
