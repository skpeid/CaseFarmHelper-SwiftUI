//
//  ImportAccountsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 13.10.2025.
//

import SwiftUI

struct ImportAccountsView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showDocumentPicker = false
    @State private var importStatus = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .padding(.bottom, 20)
                    Text("Import account from Steam")
                        .font(.title2.bold())
                }
                .padding(.top, 40)
                
                VStack {
                    InstructionStep(number: 1, text: "Create a text file with your Steam profile links (one per line), in format:")
                    Text("https://steamcommunity.com/id/username1\nhttps://steamcommunity.com/profiles/n76561197960287930")
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    InstructionStep(number: 2, text: "Save it as accounts.txt or accounts.csv")
                        .padding(.vertical, 16)
                    InstructionStep(number: 3, text: "Select the file below to import")
                }
                .padding()
                
                Spacer()
                RoundedButton(title: "Select file") {
                    showDocumentPicker.toggle()
                }
                .padding()
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { urls in
                if let fileURL = urls.first {
                    processFile(fileURL)
                }
            }
        }
    }
    
    private func processFile(_ url: URL) {
        do {
            let content = try String(contentsOf: url)
            let lines = content.components(separatedBy: .newlines)
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            
            var importedAccounts: [Account] = []
            
            for (index, line) in lines.enumerated() {
                let account = Account(
                    id: UUID(),
                    profileName: "Imported \(index + 1)",
                    username: line,
                    cases: [:],
                    profileImage: nil
                )
                importedAccounts.append(account)
            }
            
            appVM.accounts.append(contentsOf: importedAccounts)
            importStatus = "Imported \(importedAccounts.count) accounts"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
            
        } catch {
            importStatus = "Error reading file: \(error.localizedDescription)"
        }
    }
}

struct InstructionStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(number)")
                .font(.caption.bold())
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Circle().fill(.blue))
            
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}
