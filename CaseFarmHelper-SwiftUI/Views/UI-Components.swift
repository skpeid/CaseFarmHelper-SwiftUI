//
//  Components.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 29.08.2025.
//

import SwiftUI

// MARK: - AccountAvatarView
struct AccountAvatarView: View {
    let image: UIImage?
    let size: CGFloat
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: size, height: size)
                    .overlay(Image(systemName: "person"))
                    .foregroundStyle(.white)
            }
        }
        .shadow(radius: 4)
    }
}

//MARK: - RoundedButton
struct RoundedButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 20)
                .padding()
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 4)
        }
        
    }
}
