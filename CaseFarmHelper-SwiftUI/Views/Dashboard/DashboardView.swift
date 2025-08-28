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
    @State private var isPresentedAddTrade: Bool = false
    @State private var isPresentedDropDetails: Bool = false
    @State private var isPresentedTradeDetails: Bool = false
    
    @State private var selectedDrop: Drop? = nil
    @State private var selectedTrade: Trade? = nil
    
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
                                    .foregroundStyle(.black)
                            }
                            
                        case let trade as Trade:
                            Button {
                                selectedTrade = trade
                            } label: {
                                TradeCellView(trade: trade)
                                    .foregroundStyle(.black)
                            }
                        default:
                            Text("Unexpected Error")
                        }
                    }
                }
                Spacer()
                HStack {
                    Button {
                        isPresentedAddTrade.toggle()
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
            .navigationDestination(isPresented: $isPresentedAddTrade) {
                AddTradeView().environmentObject(viewModel)
            }
            .sheet(item: $selectedDrop) { drop in
                DropDetailsView(drop: drop)
                    .presentationDetents([.height(355)])
            }
            .sheet(item: $selectedTrade) { trade in
                TradeDetailsView(trade: trade)
                    .presentationDetents([.height(600)])
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
            Text(drop.account.profileName).fontWeight(.bold)
            Spacer()
            HStack {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundStyle(.green)
                VStack {
                    Image(drop.caseDropped.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.dashboardCaseSize, height: Constants.dashboardCaseSize)
                    Text(drop.monthDayString)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
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
            
            HStack {
                Image(systemName: "arrow.right.arrow.left")
                    .font(.headline)
                    .foregroundStyle(.orange)
                VStack {
                    Text("x1")
                        .font(.headline)
                        .frame(height: Constants.dashboardCaseSize)
                    Text(trade.monthDayString)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
