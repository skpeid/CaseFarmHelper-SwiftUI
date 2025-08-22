//
//  DashboardView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject var viewModel = OperationViewModel()
    @EnvironmentObject var accountsViewModel: AccountsViewModel
    
    @State private var isPresentedAddDrop: Bool = false
    @State private var isPresentedTrade: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.operations) { operation in
                        switch operation {
                        case let drop as Drop:
                            HStack {
                                Text(drop.account.profileName)
                                Spacer()
                                Text(drop.caseDropped.displayName)
                                Text(drop.formattedDate)
                            }
                        case let trade as Trade:
                            HStack {
                                Text(trade.sender.profileName + "  -> ")
                                Text(trade.receiver.profileName)
                                Spacer()
                                Text(trade.caseTraded.displayName)
                            }
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
                        Text("Trade")
                    }
                    Button {
                        isPresentedAddDrop.toggle()
                    } label: {
                        Text("Add Drop")
                    }
                    
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(isPresented: $isPresentedAddDrop) {
                AddDropView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $isPresentedTrade) {
                AddTradeView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    DashboardView()
}
