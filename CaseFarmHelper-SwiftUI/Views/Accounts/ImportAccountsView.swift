//
//  ImportAccountsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 13.10.2025.
//

import SwiftUI

enum ImportState {
    case idle
    case processing(lines: [String])
    case inProgress(current: Int, total: Int, accounts: [Account])
    case completed(successCount: Int, failedCount: Int)
    case error(String)
}

struct ImportAccountsView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showDocumentPicker = false
    @State private var importState = ImportState.idle
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .padding(.bottom, 20)
                    Text("Batch import accounts from Steam")
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
                
                Group {
                    switch importState {
                    case .idle:
                        EmptyView()
                        
                    case .processing(let lines):
                        VStack {
                            ProgressView()
                            Text("Preparing to import \(lines.count) accounts...")
                        }
                        
                    case .inProgress(let current, let total, _):
                        VStack {
                            ProgressView(value: Double(current), total: Double(total))
                                .progressViewStyle(LinearProgressViewStyle())
                            Text("Fetching \(current)/\(total)")
                                .font(.caption)
                        }
                        .padding()
                        
                    case .completed(let success, let failed):
                        VStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 40))
                            Text("Imported \(success) accounts")
                            if failed > 0 {
                                Text("\(failed) failed to import")
                                    .foregroundColor(.red)
                            }
                        }
                        
                    case .error(let message):
                        Text("Error: \(message)")
                            .foregroundColor(.red)
                    }
                }
                
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
                    Task {
                        await processFile(fileURL)
                    }
                }
            }
        }
    }
    
    private func processFile(_ url: URL) async {
        do {
            let content = try String(contentsOf: url)
            let lines = content.components(separatedBy: .newlines)
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            
            await MainActor.run {
                importState = .processing(lines: lines)
            }
            
            await importAccounts(from: lines)
            
        } catch {
            await MainActor.run {
                importState = .error("Failed to read file: \(error.localizedDescription)")
            }
        }
    }
    
    private func importAccounts(from identifiers: [String]) async {
        var importedAccounts: [Account] = []
        var successCount = 0
        var failedCount = 0
        
        for (index, identifier) in identifiers.enumerated() {
            await MainActor.run {
                importState = .inProgress(current: index, total: identifiers.count, accounts: importedAccounts)
            }
            
            if let profile = await SteamService().fetchSteamProfile(identifier: identifier) {
                let profileImage = await SteamService().downloadImage(from: profile.avatarfull)
                
                let account = Account(
                    id: UUID(),
                    profileName: profile.personaname,
                    username: profile.steamid,
                    cases: [:],
                    profileImage: profileImage
                )
                importedAccounts.append(account)
                successCount += 1
            } else {
                failedCount += 1
            }
            
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        
        await MainActor.run {
            appVM.accounts.append(contentsOf: importedAccounts)
            importState = .completed(successCount: successCount, failedCount: failedCount)
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        await MainActor.run {
            dismiss()
        }
    }
    
    private func fetchSteamAccount(identifier: String) async -> Account? {
        guard let profile = await SteamService().fetchSteamProfile(identifier: identifier) else {
            return nil
        }
        
        let profileImage = await SteamService().downloadImage(from: profile.avatarfull)
        
        return Account(
            id: UUID(),
            profileName: profile.personaname,
            username: profile.steamid,
            cases: [:],
            profileImage: profileImage
        )
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

extension ImportState {
    var isInProgress: Bool {
        if case .inProgress = self { return true }
        return false
    }
}
