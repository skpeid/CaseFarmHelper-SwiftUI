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
                VStack() {
                    AccountAvatarView(image: account.profileImage, size: Constants.smallAvatarSize)
                        .padding(8)
                        .background(account.gotDropThisWeek ? .green.opacity(0.3) : .clear)
                }
            }
        }
    }
    
    private var weekInfoText: some View {
        let resetWeekday = 4
        let resetHour = 6
        var nextReset: Date {
            let now = Date()
            let calendar = Calendar.current
            var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
            components.weekday = resetWeekday
            components.hour = resetHour
            components.minute = 0
            components.second = 0
            
            return calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)!
        }
        
        var nextResetString: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            return formatter.string(from: nextReset)
        }
        
        return Text("Week \(Date().weekOfYear) · till \(nextResetString)").fontWeight(.semibold).foregroundStyle(.black)
    }
}

//MARK: - Drop Cell
struct DropCellView: View {
    let drop: Drop
    
    var body: some View {
        HStack {
            AccountAvatarView(image: drop.account.profileImage, size: Constants.menuAvatarSize)
            VStack(alignment: .leading) {
                Text(drop.account.profileName).fontWeight(.bold)
                Text("collected drop")
                    .foregroundStyle(.gray)
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
            AccountAvatarView(image: trade.receiver.profileImage, size: Constants.menuAvatarSize)
            VStack(alignment: .leading) {
                Text(trade.receiver.profileName).fontWeight(.bold)
                Text("received trade from ")
                    .foregroundStyle(.gray)
                    .font(.caption) + Text(trade.sender.profileName).fontWeight(.semibold).font(.caption)
            }
            Spacer()
            HStack {
                Image(systemName: "arrow.right.arrow.left")
                    .font(.headline)
                    .foregroundStyle(Constants.tradeColor)
                VStack {
                    Text("x\(trade.totalTraded)")
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
