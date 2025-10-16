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
    @State private var isPresentedAddPurchase: Bool = false
    @State private var isPresentedDropDetails: Bool = false
    @State private var isPresentedTradeDetails: Bool = false
    @State private var isPresentedDropStatus: Bool = false
    
    @State private var selectedDrop: Drop? = nil
    @State private var selectedTrade: Trade? = nil
    @State private var selectedPurchase: Purchase? = nil
    
    @State private var dropToDelete: Drop?
    @State private var tradeToDelete: Trade?
    @State private var purchaseToDelete: Purchase?
    @State private var showDeleteAlert = false
    
    private var operationToDelete: Operation? {
        dropToDelete ?? tradeToDelete ?? purchaseToDelete
    }
    
    private var alertTitle: String {
        if dropToDelete != nil { return "Delete Drop" }
        if tradeToDelete != nil { return "Undo Trade" }
        if purchaseToDelete != nil { return "Delete Purchase" }
        return "Delete Operation"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: HStack(alignment: .bottom) {
                    InfoSectionView(title: "STATUS") {
                        VStack(alignment: .leading) {
                            Text("This week's progress:")
                            Text("GREEN").foregroundStyle(.green).bold() + Text(" - collected drop.")
                            Text("RED").foregroundStyle(.red).bold() + Text(" - didn't received yet.")
                            
                        }
                        .textCase(.none)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    Spacer()
                    weekInfoText
                }) {
                    accountsDropStatusGrid
                        .onTapGesture {
                            isPresentedDropStatus.toggle()
                        }
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
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        dropToDelete = drop
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                                
                            case let trade as Trade:
                                Button {
                                    selectedTrade = trade
                                } label: {
                                    TradeCellView(trade: trade)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        tradeToDelete = trade
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                                
                            case let purchase as Purchase:
                                Button {
                                    selectedPurchase = purchase
                                } label: {
                                    PurchaseCellView(purchase: purchase)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        purchaseToDelete = purchase
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                                
                            default:
                                Text("Unexpected Error")
                            }
                        }
                    }
                    .alert(alertTitle, isPresented: $showDeleteAlert) {
                        Button("Cancel", role: .cancel) {
                            dropToDelete = nil
                            tradeToDelete = nil
                            purchaseToDelete = nil
                        }
                        if let trade = tradeToDelete {
                            Button("Undo", role: .destructive) {
                                viewModel.deleteTrade(trade)
                                tradeToDelete = nil
                            }
                        } else {
                            Button("Delete", role: .destructive) {
                                if let drop = dropToDelete {
                                    viewModel.deleteDrop(drop)
                                } else if let purchase = purchaseToDelete {
                                    viewModel.deletePurchase(purchase)
                                }
                                dropToDelete = nil
                                purchaseToDelete = nil
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isPresentedAddPurchase.toggle()
                    } label: {
                        Image(systemName: "dollarsign")
                            .fontWeight(.semibold)
                    }
                    
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
            .navigationDestination(isPresented: $isPresentedAddPurchase) {
                AddPurchaseView().environmentObject(viewModel)
            }
            .navigationDestination(isPresented: $isPresentedAddDrop) {
                AddDropView().environmentObject(viewModel)
            }
            .navigationDestination(isPresented: $isPresentedAddTrade) {
                AddTradeView().environmentObject(viewModel)
            }
            .sheet(item: $selectedDrop) { drop in
                DropDetailsView(drop: drop)
                    .presentationDetents([.medium])
            }
            .sheet(item: $selectedTrade) { trade in
                TradeDetailsView(trade: trade)
                    .presentationDetents([.large])
            }
            .sheet(item: $selectedPurchase) { purchase in
                PurchaseDetailsView(purchase: purchase)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $isPresentedDropStatus) {
                dropStatusView
                    .presentationDetents([.large])
            }
        }
    }
    
    private var dropStatusView: some View {
        return VStack {
            ModalSheetHeaderView(title: "Drop Status")
                .padding()
            List {
                ForEach(viewModel.accounts) { account in
                    HStack {
                        AccountAvatarView(image: account.profileImage, size: Constants.menuAvatarSize)
                        Text(account.profileName)
                            .foregroundStyle(Color(.label))
                            .fontWeight(.bold)
                            .strikethrough(account.gotDropThisWeek)
                        if account.gotDropThisWeek {
                            Image(systemName: "checkmark")
                                .bold()
                                .foregroundStyle(.green)
                        }
                        Spacer()
                        if account.gotDropThisWeek {
                            if let date = account.lastDropDate {
                                Text(date.fullDateString())
                                    .font(.caption2)
                            }
                        }
                    }
                }
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

//MARK: - Purchase Cell
struct PurchaseCellView: View {
    let purchase: Purchase
    
    var body: some View {
        HStack {
            AccountAvatarView(image: purchase.account.profileImage, size: Constants.menuAvatarSize)
            VStack(alignment: .leading) {
                Text(purchase.account.profileName)
                    .foregroundStyle(Color(.label))
                    .fontWeight(.bold)
                Text("purchased ")
                    .foregroundStyle(Color(.secondaryLabel))
                    .font(.caption) + Text("x\(purchase.amount) \(purchase.casePurchased.displayName)s ").foregroundStyle(Color(.label)).fontWeight(.semibold).font(.caption)
            }
            Spacer()
            HStack {
                Image(systemName: "dollarsign")
                    .font(.headline)
                    .foregroundStyle(Constants.purchaseColor)
                VStack {
                    Image(purchase.casePurchased.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.dashboardCaseSize, height: Constants.dashboardCaseSize)
                    Text(purchase.monthDayString)
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }
        }
    }
}
