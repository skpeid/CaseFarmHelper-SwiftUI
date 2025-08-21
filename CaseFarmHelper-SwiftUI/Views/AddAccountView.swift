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
                    TextField("0", text: .constant(""))
                        .frame(width: 50)
                        .keyboardType(.numberPad)
                }
            }
            Spacer()
            Button {
                
            } label: {
                Text("Add Account")
            }

        }
    }
}

#Preview {
    AddAccountView()
}
