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
}
