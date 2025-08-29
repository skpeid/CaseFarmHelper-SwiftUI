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
            HStack(alignment: .center) {
                Circle()
                    .fill(.gray)
                    .frame(width: 100, height: 100)
                    .overlay(Text("Select"))
                    .foregroundStyle(.white)
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
                .padding(.horizontal)
            }
            .padding()
            .onTapGesture {
                showImagePicker.toggle()
            }
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
            RoundedButton(title: "Add Account") {
                guard let image = selectedImage else { return }
                let newAccount = Account(profileName: profileName, username: username, cases: cases, profileImage: image)
                viewModel.addAccount(newAccount)
                dismiss()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
        .padding()
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
