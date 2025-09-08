//
//  InventoryValueView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 08.09.2025.
//

import SwiftUI

struct InventoryValueView: View {
    @StateObject private var viewModel = StatsViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(CSCase.allCases) { csCase in
                    VStack {
                        Text(csCase.displayName)
                        if let price = viewModel.casePrices[csCase] {
                            Text("Lowest: \(price.lowestPrice ?? "N/A")")
                            Text("Median: \(price.medianPrice ?? "N/A")")
                            Text("Volume: \(price.volume ?? "N/A")")
                        } else if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                Text("Loading...")
                            }
                        } else {
                            Text("...")
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Inventory Value")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Refresh") {
                    Task { await viewModel.fetchAllCases() }
                }
            }
        }
        .task {
            await viewModel.fetchAllCases()
        }
    }
}

#Preview {
    InventoryValueView()
}
