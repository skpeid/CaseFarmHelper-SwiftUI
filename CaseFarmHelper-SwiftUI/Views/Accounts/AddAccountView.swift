//
//  AddAccountView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 21.08.2025.
//

import SwiftUI

struct AddAccountView: View {
    @State private var profileName: String = ""
    @State private var username: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var cases: [CSCase: Int] = [:]
    @State private var usernameError: String?
    
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    private var isFormValid: Bool {
        !profileName.isEmpty &&
        !username.isEmpty &&
        usernameError == nil
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Account Info")) {
                    HStack(alignment: .top) {
                        VStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 28))
                                            .foregroundStyle(.white)
                                    )
                            }
                        }
                        .padding(.top, 28)
                        .onTapGesture {
                            showImagePicker.toggle()
                        }
                        
                        VStack {
                            Text("Profile Name")
                            TextField("Profile Name", text: $profileName)
                                .textFieldStyle(.roundedBorder)
                                .padding(.bottom)
                            Text("Username")
                            TextField("Username", text: $username)
                                .textFieldStyle(.roundedBorder)
                                .onChange(of: username) { newValue in
                                    validateUsername(newValue)
                                }
                            
                            if let error = usernameError {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        .padding(.leading)
                    }
                }
                
                Section(header: Text("Initial Cases")) {
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
                }
            }
            
            Spacer()
            RoundedButton(title: "Add Account") {
                if isFormValid {
                    let newAccount = Account(profileName: profileName, username: username, cases: cases, profileImage: selectedImage)
                    viewModel.addAccount(newAccount)
                    viewModel.saveAccounts()
                    dismiss()
                }
            }
            .padding([.horizontal, .bottom])
            .disabled(!isFormValid)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    private func binding(for csCase: CSCase) -> Binding<String> {
        return Binding<String>(
            get: {
                String(cases[csCase] ?? 0)
            },
            set: { newValue in
                if let value = Int(newValue), value >= 0 {
                    cases[csCase] = value
                } else if newValue.isEmpty {
                    cases[csCase] = 0
                }
            }
        )
    }
    
    private func validateUsername(_ username: String) {
        let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
        
        if trimmedUsername.isEmpty {
            usernameError = nil
        } else if !viewModel.isUsernameUnique(trimmedUsername) {
            usernameError = "This username is already used by another account"
        } else {
            usernameError = nil
        }
    }
}

// MARK: ImagePicker for choosing profile image from Photo Library
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
