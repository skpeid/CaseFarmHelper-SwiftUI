//
//  SteamService.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 14.10.2025.
//

import SwiftUI

struct SteamResponse: Codable {
    let response: PlayerResponse
}

struct PlayerResponse: Codable {
    let players: [SteamProfile]
}

struct SteamProfile: Codable {
    let steamid: String
    let personaname: String
    let avatarfull: String
}

struct VanityUrlResponse: Codable {
    let response: VanityUrlResult
}

struct VanityUrlResult: Codable {
    let steamid: String?
    let success: Int
}

final class SteamService {
    private let apiKey = "9C8452B9CD84ED65F464EA69912C5DE9"
    
    func fetchSteamProfile(identifier: String) async -> SteamProfile? {
        var steamId = extractSteamId(from: identifier)
        print("__________________________________________________________________________________________")
        if !isNumericSteamId(steamId) {
            print("Resolving custom URL: \(steamId)")
            if let resolvedId = await resolveCustomUrl(steamId) {
                steamId = resolvedId
                print("Resolved to SteamID: \(steamId)")
            } else {
                print("Failed to resolve custom URL")
                return nil
            }
        }
        
        let urlString = "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=\(apiKey)&steamids=\(steamId)"
        
        print("Fetching Steam profile for: \(identifier)")
        print("Using SteamID: \(steamId)")
        print("URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SteamResponse.self, from: data)
            
            if let profile = response.response.players.first {
                print("Profile found: \(profile.personaname)")
                return profile
            } else {
                print("No profile found in response")
                return nil
            }
        } catch {
            print("Steam API error: \(error)")
            return nil
        }
    }
    
    private func isNumericSteamId(_ id: String) -> Bool {
        return id.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil && id.count == 17
    }
    
    private func resolveCustomUrl(_ customUrl: String) async -> String? {
        let resolveUrlString = "https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/?key=\(apiKey)&vanityurl=\(customUrl)"
        
        guard let url = URL(string: resolveUrlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(VanityUrlResponse.self, from: data)
            
            if response.response.success == 1 {
                return response.response.steamid
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    private func extractSteamId(from input: String) -> String {
        var cleanedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedInput.hasSuffix("/") {
            cleanedInput = String(cleanedInput.dropLast())
        }
        
        if cleanedInput.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil,
           cleanedInput.count == 17 {
            return cleanedInput
        }
        
        if let url = URL(string: cleanedInput),
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            
            if components.path.hasPrefix("/profiles/") {
                return components.path.replacingOccurrences(of: "/profiles/", with: "")
            }
            
            if components.path.hasPrefix("/id/") {
                return components.path.replacingOccurrences(of: "/id/", with: "")
            }
        }
        
        return cleanedInput
    }
}
