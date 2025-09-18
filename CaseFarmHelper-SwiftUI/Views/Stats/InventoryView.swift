//
//  InventoryView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 11.09.2025.
//

import SwiftUI

struct InventoryView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            ModalSheetHeaderView(title: "Inventory")
                .padding()
            List {
                let sortedCases = CSCase.allCases.map { csCase in
                    (csCase, viewModel.accounts.map { $0.cases[csCase] ?? 0 }
                            .reduce(0, +))
                }
                    .sorted {
                        if $0.1 == $1.1 {
                            return $0.0.rawValue < $1.0.rawValue
                        }
                        return $0.1 > $1.1
                    }
                ForEach(sortedCases, id: \.0) { csCase, totalAmount in
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
