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
    @State private var showProfileName: Bool = false
    
    @State private var selectedDrop: Drop? = nil
    @State private var selectedTrade: Trade? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: HStack {
                    Text("Status")
                    Spacer()
                    weekInfoText
                }) {
                    accountsDropStatusGrid
                }
                
                Section(header: Text("Operations")) {
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
                                Button {
                                    selectedTrade = trade
                                } label: {
                                    TradeCellView(trade: trade)
                                }
                            default:
                                Text("Unexpected Error")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isPresentedAddTrade.toggle()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                            .fontWeight(.semibold)
                    }
                    
                    Button {
                        isPresentedAddDrop.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                    
                    Button {
                        viewModel.deleteOperations()
                    } label: {
                        Image(systemName: "trash")
                            .fontWeight(.semibold)
                    }
                }
            }
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
                    .presentationDetents([.large])
            }
        }
    }
    
    private var accountsDropStatusGrid: some View {
        let sortedAccounts = viewModel.accounts.sorted {
            if $0.gotDropThisWeek == $1.gotDropThisWeek {
                return $0.profileName < $1.profileName
            }
            return !$0.gotDropThisWeek && $1.gotDropThisWeek
        }
        
        return LazyVGrid(columns: Constants.accountsProgressColumns) {
            ForEach(sortedAccounts) { account in
                VStack {
                    AccountAvatarView(image: account.profileImage, size: Constants.smallAvatarSize)
                        .overlay(
                            Circle().stroke(account.gotDropThisWeek ? .green : .red, lineWidth: 3)
                        )
                }
            }
        }
    }
    
    private var weekInfoText: some View {
        let calendar = Calendar.current
        let now = Date()
        
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        components.weekday = 4
        components.hour = 6
        components.minute = 0
        components.second = 0
        
        guard let  thisWeekReset = calendar.date(from: components) else { return Text("Error computing week") }
        
        let weekStart: Date
        let weekEnd: Date
        
        if now < thisWeekReset {
            weekStart = calendar.date(byAdding: .day, value: -7, to: thisWeekReset)!
            weekEnd = thisWeekReset
        } else {
            weekStart = thisWeekReset
            weekEnd = calendar.date(byAdding: .day, value: 7, to: thisWeekReset)!
        }
        
        let weekOfYear = calendar.component(.weekOfYear, from: weekStart)
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        
        return Text("Week \(weekOfYear) · till \(formatter.string(from: weekEnd))")
            .foregroundStyle(Color(.label))
            .fontWeight(.semibold)
    }
}

//MARK: - Drop Cell
struct DropCellView: View {
    let drop: Drop
    
    var body: some View {
        HStack {
            AccountAvatarView(image: drop.account.profileImage, size: Constants.menuAvatarSize)
            VStack(alignment: .leading) {
                Text(drop.account.profileName)
                    .foregroundStyle(Color(.label))
                    .fontWeight(.bold)
                Text("collected drop")
                    .foregroundStyle(Color(.secondaryLabel))
                    .font(.caption)
            }
            Spacer()
            HStack {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundStyle(Constants.dropColor)
                VStack {
                    Image(drop.caseDropped.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.dashboardCaseSize, height: Constants.dashboardCaseSize)
                    Text(drop.monthDayString)
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
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
            AccountAvatarView(image: trade.receiver.profileImage, size: Constants.menuAvatarSize)
            VStack(alignment: .leading) {
                Text(trade.receiver.profileName)
                    .foregroundStyle(Color(.label))
                    .fontWeight(.bold)
                Text("received trade from ")
                    .foregroundStyle(Color(.secondaryLabel))
                    .font(.caption) + Text(trade.sender.profileName).foregroundStyle(Color(.label)).fontWeight(.semibold).font(.caption)
            }
            Spacer()
            HStack {
                Image(systemName: "arrow.right.arrow.left")
                    .font(.headline)
                    .foregroundStyle(Constants.tradeColor)
                VStack {
                    Text("x\(trade.totalTraded)")
                        .foregroundStyle(Color(.label))
                        .font(.headline)
                        .frame(height: Constants.dashboardCaseSize)
                    Text(trade.monthDayString)
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }
        }
    }
}
