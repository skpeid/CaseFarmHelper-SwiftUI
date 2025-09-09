//
//  CasesTickerView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 09.09.2025.
//

import SwiftUI

struct CasesTickerView: View {
    let prices: [CSCase: CasePrice]
    @State private var offset: CGFloat = 0
    @State private var totalWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 16) {
                content
                content
            }
            .offset(x: offset)
            .background(
                GeometryReader { proxy in
                    Color.clear.onAppear {
                        totalWidth = proxy.size.width / 2
                        startScrolling()
                    }
                }
            )
        }
        .frame(height: 60)
        .clipped()
    }

    private var content: some View {
        HStack {
            ForEach(CSCase.allCases, id: \.self) { cs in
                HStack {
                    Image(cs.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading) {
                        Text(cs.rawValue).font(.caption2)
                        Text(prices[cs]?.lowestPrice ?? "...").foregroundColor(.green)
                    }
                }
                .frame(width: 140, height: 60)
            }
        }
    }

    private func startScrolling() {
        let duration = 30.0
        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
            offset = -totalWidth
        }
    }
}
