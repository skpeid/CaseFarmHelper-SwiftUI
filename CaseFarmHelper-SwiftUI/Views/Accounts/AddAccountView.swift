//
//  AddAccountView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AddAccountView: View {
    
    @State var profileName: String = ""
    @State var username: String = ""
    @State var cases: [CSCase: Int] = [:]
    
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Profile Name")
            TextField("Profile Name", text: $profileName)
                .textFieldStyle(.roundedBorder)
            Text("Username")
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
            ForEach(CSCase.allCases) { csCase in
                HStack {
                    Image(csCase.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                    Text(csCase.displayName)
                    Spacer()
                    TextField("0", text: binding(for: csCase))
                        .frame(width: 50)
                        .keyboardType(.numberPad)
                }
            }
            Spacer()
            Button {
                let newAccount = Account(profileName: profileName, username: username, cases: cases)
                viewModel.addAccount(newAccount)
                dismiss()
            } label: {
                Text("Add Account")
            }
            
        }
    }
    
    private func binding(for key: CSCase) -> Binding<String> {
        Binding<String>(
            get: {
                String(cases[key] ?? 0)
            },
            set: { newValue in
                cases[key] = Int(newValue) ?? 0
            }
        )
    }
}

#Preview {
    AddAccountView()
}
