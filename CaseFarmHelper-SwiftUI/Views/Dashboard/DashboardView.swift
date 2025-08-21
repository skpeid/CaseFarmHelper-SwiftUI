//
//  DashboardView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct DashboardView: View {
    
    @State var operations: [Operation] = [
        Drop(account: Account(profileName: "jks", username: ""), caseDropped: .dreamsAndNightmares),
        Trade(sender: Account(profileName: "skpeid", username: ""), receiver: Account(profileName: "ObserWard", username: ""), caseTraded: .recoil),
        Drop(account: Account(profileName: "jks", username: ""), caseDropped: .fracture)
    ]
    
    @State private var isPresentedAddDrop: Bool = false
    @State private var isPresentedTrade: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(operations) { operation in
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
                        
                    } label: {
                        Text("Trade")
                    }
                    Button {
                        
                    } label: {
                        Text("Add Drop")
                    }
                    
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(isPresented: $isPresentedAddDrop) {
                
            }
            .navigationDestination(isPresented: $isPresentedTrade) {
                
            }
        }
    }
}

#Preview {
    DashboardView()
}
