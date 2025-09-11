//
//  InventoryView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 11.09.2025.
//

import SwiftUI

struct InventoryView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            ModalSheetHeaderView(title: "Inventory")
                .padding()
            List {
                ForEach(CSCase.allCases, id: \.self) { csCase in
                    let totalAmount = viewModel.accounts
                        .map { $0.cases[csCase] ?? 0 }
                        .reduce(0, +)
                    
                    HStack {
                        Image(csCase.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Text(csCase.displayName)
                            .padding(.horizontal)
                        Spacer()
                        Text("\(totalAmount)")
                    }
                }
            }
        }
    }
}
