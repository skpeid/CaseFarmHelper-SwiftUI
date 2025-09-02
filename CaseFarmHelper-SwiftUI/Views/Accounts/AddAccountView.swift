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
    
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Account Info")) {
                    HStack(alignment: .center) {
                        VStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 100, height: 100)
                                    .overlay(Text("Select"))
                                    .foregroundStyle(.white)
                            }
                        }
                        .shadow(radius: 4)
                        
                        VStack {
                            Text("Profile Name")
                            TextField("Profile Name", text: $profileName)
                                .textFieldStyle(.roundedBorder)
                                .padding(.bottom)
                            Text("Username")
                            TextField("Username", text: $username)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(.leading)
                    }
                    .onTapGesture {
                        showImagePicker.toggle()
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
                if profileName.isEmpty || username.isEmpty { return }
                let newAccount = Account(profileName: profileName, username: username, cases: cases, profileImage: selectedImage)
                viewModel.addAccount(newAccount)
                dismiss()
            }
            .padding([.horizontal, .bottom])
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
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
