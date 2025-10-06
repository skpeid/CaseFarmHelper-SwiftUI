//
//  AccountDetailsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AccountDetailsView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var isEditing: Bool = false
    @State private var editedProfileName: String = ""
    @State private var editedProfileImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var editedCases: [CSCase: Int] = [:]
    let account: Account
    
    var body: some View {
        Form {
            Section(header: Text("Account Info")) {
                HStack(alignment: .center) {
                    VStack {
                        if let image = (isEditing ? editedProfileImage : account.profileImage) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color(.systemGray4))
                                .frame(width: 100, height: 100)
                                .overlay(Image(systemName: "person.fill"))
                                .font(.system(size: 28))
                                .foregroundStyle(.white)
                        }
                    }
                    .onTapGesture {
                        if isEditing {
                            showImagePicker.toggle()
                        }
                    }
                    .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("Profile Name")
                        if isEditing {
                            TextField("Profile Name", text: $editedProfileName)
                                .overlay(
                                        HStack {
                                            Spacer()
                                            Image(systemName: "pencil")
                                                .foregroundColor(.secondary)
                                                .padding(.trailing, 8)
                                        }
                                    )
                        } else {
                            Text(account.profileName).fontWeight(.semibold)
                        }
                        Divider()
                        Text("Username")
                        Text("@\(account.username)").fontWeight(.semibold)
                    }
                    .padding(.leading)
                }
            }
            
                Section(header: HStack {
                    Text("Current Cases")
                    Spacer()
                    Text("Total: \(account.getTotalCasesAmount)").fontWeight(.semibold)
                }) {
                    LazyVGrid(columns: Constants.caseColumns) {
                        ForEach(account.cases.sorted(by: { $0.value > $1.value })
                            .filter { $0.value > 0 }, id: \.key) { csCase, amount in
                            VStack {
                                Image(csCase.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 90)
                                Text(csCase.displayName)
                                    .lineLimit(1)
                                    .font(.caption)
                                Text("x\(amount)")
                                    .font(.headline)
                            }
                        }
                    }
                }
            
        }
        .toolbar {
            if isEditing {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        saveChanges()
                        isEditing = false
                    }
                }
            }
            else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        editedProfileName = account.profileName
                        editedCases = account.cases
                        editedProfileImage = account.profileImage
                        isEditing = true
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $editedProfileImage)
        }
    }
    
    private func saveChanges() {
        account.profileName = editedProfileName
        account.profileImage = editedProfileImage
        account.cases = editedCases
        appVM.reloadAccounts()
        appVM.saveAccounts()
    }
}
