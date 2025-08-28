//
//  DashboardView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var isPresentedAddDrop: Bool = false
    @State private var isPresentedTrade: Bool = false
    @State private var isPresentedDropDetails: Bool = false
    
    @State private var selectedDrop: Drop? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.operations) { operation in
                        switch operation {
                        case let drop as Drop:
                            Button {
                                selectedDrop = drop
                            } label: {
                                DropCellView(drop: drop)
                            }

                        case let trade as Trade:
                            TradeCellView(trade: trade)
                        default:
                            Text("Unknown operation")
                        }
                    }
                }
                Spacer()
                HStack {
                    Button {
                        isPresentedTrade.toggle()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 20)
                            .padding()
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    Button {
                        isPresentedAddDrop.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 20)
                            .padding()
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(isPresented: $isPresentedAddDrop) {
                AddDropView().environmentObject(viewModel)
            }
            .navigationDestination(isPresented: $isPresentedTrade) {
                AddTradeView().environmentObject(viewModel)
            }
            .sheet(item: $selectedDrop) { drop in
                DropDetailsView(drop: drop)
                    .presentationDetents([.height(355)])
            }
        }
    }
}

//MARK: - Drop Cell
struct DropCellView: View {
    let drop: Drop
    
    var body: some View {
        HStack {
            if let image = drop.account.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: Constants.menuAvatarSize, height: Constants.menuAvatarSize)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: Constants.menuAvatarSize, height: Constants.menuAvatarSize)
                    .overlay(Image(systemName: "person"))
                    .foregroundStyle(.white)
            }
            Spacer()
            Image(systemName: "plus")
                .font(.system(size: 18, weight: .semibold))
            Image(drop.caseDropped.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.dashboardCaseSize, height: Constants.dashboardCaseSize)
            Text(drop.monthDayString)
        }
    }
}

//MARK: - Trade Cell
struct TradeCellView: View {
    let trade: Trade
    
    var body: some View {
        HStack {
            if let image = trade.sender.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: Constants.menuAvatarSize, height: Constants.menuAvatarSize)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: Constants.menuAvatarSize, height: Constants.menuAvatarSize)
                    .overlay(Image(systemName: "person"))
                    .foregroundStyle(.white)
            }
            Image(systemName: "arrow.left.arrow.right")
                .font(.system(size: 18, weight: .semibold))
            if let image = trade.receiver.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: Constants.menuAvatarSize, height: Constants.menuAvatarSize)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: Constants.menuAvatarSize, height: Constants.menuAvatarSize)
                    .overlay(Image(systemName: "person"))
                    .foregroundStyle(.white)
            }
            Spacer()
//            Image(trade.casesTraded.imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: Constants.dashboardCaseSize, height: Constants.dashboardCaseSize)
            
            Text(trade.monthDayString)
        }
    }
}
