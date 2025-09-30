//
//  CasesTickerView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 09.09.2025.
//

import SwiftUI

struct CasesTickerView: View {
    @EnvironmentObject private var appVM: AppViewModel
    let prices: [CSCase: CasePrice]
    @State private var offset: CGFloat = 0
    @State private var totalWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            HStack {
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
        .frame(height: Constants.tickerHeight)
        .clipped()
    }

    private var content: some View {
        HStack {
            ForEach(CSCase.activeDrop, id: \.self) { cs in
                HStack {
                    Image(cs.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading) {
                        Text(cs.tickerName)
                            .foregroundColor(Color(.label))
                            .font(.headline)
                        Text(prices[cs]?.lowestPrice ?? "N/A")
                            .foregroundColor(Color(.label))
                            .font(.headline)
                    }
                    Spacer()
                }
                .frame(width: Constants.tickerWidth)
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
