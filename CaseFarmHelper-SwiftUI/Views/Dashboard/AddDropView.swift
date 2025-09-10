//
//  AddDropView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AddDropView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var selectedAccount: Account?
    @State var selectedCase: CSCase?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                LazyVGrid(columns: Constants.accountColumns) {
                    ForEach(viewModel.accounts) { account in
                        VStack {
                            AccountAvatarView(image: account.profileImage, size: Constants.menuAvatarSize)
                                .overlay(
                                    Circle().stroke(selectedAccount?.id == account.id ? .green : .gray,
                                                    lineWidth: selectedAccount?.id == account.id ? 3 : 1)
                                )
                            Text(account.profileName)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .padding()
                        .background(selectedAccount?.id == account.id ? Color(.systemGray4) : .clear)
                        .onTapGesture {
                            if account == selectedAccount {
                                selectedAccount = nil
                            } else { selectedAccount = account }
                        }
                    }
                }
            }
            Divider()
            ScrollView {
                LazyVGrid(columns: Constants.caseColumns) {
                    ForEach(CSCase.allCases) { csCase in
                        VStack {
                            Image(csCase.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: Constants.bigCaseSize, height: Constants.bigCaseSize)
                            Text(csCase.displayName)
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                        }
                        .padding()
                        .overlay(
                            Rectangle().stroke(selectedCase?.id == csCase.id ? Color.gray : .clear, lineWidth: 1)
                        )
                        .background(selectedCase?.id == csCase.id ? Color(.systemGray4) : .clear)
                        .onTapGesture {
                            if csCase == selectedCase {
                                selectedCase = nil
                            } else { selectedCase = csCase }
                        }
                    }
                }
            }
            Spacer()
            RoundedButton(title: "Save") {
                guard let selectedAccount = selectedAccount, let selectedCase = selectedCase else { return }
                viewModel.addDrop(to: selectedAccount, csCase: selectedCase)
                dismiss()
            }
        }
        .padding()
        .navigationTitle("Add Drop")
        .navigationBarTitleDisplayMode(.inline)
    }
}
