//
//  InfoSectionView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 08.10.2025.
//

import SwiftUI

struct InfoSectionView<Content: View>: View {
    let title: String
    let infoContent: Content
    @State private var isExpanded = false
    
    init(title: String, @ViewBuilder infoContent: () -> Content) {
        self.title = title
        self.infoContent = infoContent()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                }
            }
            
            if isExpanded {
                infoContent
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .padding()
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.blue.opacity(0.5))
                    )
            }
        }
    }
}
