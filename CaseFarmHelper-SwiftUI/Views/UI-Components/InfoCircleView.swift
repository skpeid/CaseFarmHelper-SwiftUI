//
//  InfoCircleView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 11.09.2025.
//

import SwiftUI

struct InfoCircleView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.clear)
                    .frame(width: Constants.infoCircleSize, height: Constants.infoCircleSize)
                    .overlay(
                        Circle().stroke(.green, lineWidth: 3)
                    )
                VStack(spacing: 12) {
                    Text(title)
                        .font(.caption)
                    Text(value)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Image(systemName: "chevron.right")
                }
            }
            
        }
    }
}
