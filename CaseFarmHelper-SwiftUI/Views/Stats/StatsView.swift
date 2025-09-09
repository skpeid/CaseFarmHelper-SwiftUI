//
//  StatsView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 22.08.2025.
//

import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @State private var isPresentedInventoryValue: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CaseTickerView(prices: viewModel.casePrices)
                Spacer()
                RoundedButton(title: "Get Value") {
                    isPresentedInventoryValue.toggle()
                }
                .padding()
                .navigationTitle("Stats")
                //                .navigationDestination(isPresented: $isPresentedInventoryValue) {
                //                    InventoryValueView()
                //                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAllCases()
            }
        }
    }
}
#Preview {
    StatsView()
}

struct CaseTickerView: View {
    let prices: [CSCase: CasePrice]
    @State private var offset: CGFloat = 0
    @State private var totalWidth: CGFloat = 0
    @State private var animationActive = false

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 16) {
                content
                content
            }
            .background(
                GeometryReader { proxy in
                    Color.clear.onAppear {
                        totalWidth = proxy.size.width / 2
//                        startScrolling()
                    }
                }
            )
            .offset(x: offset)
        }
        .clipped()
    }

    private var content: some View {
        HStack {
                ForEach(CSCase.allCases, id: \.self) { cs in
                    HStack() {
                        Divider()
                        Image(cs.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)

                        VStack {
                            Text(cs.rawValue)
                                .font(.caption)
                                .lineLimit(1)

                            if let price = prices[cs]?.lowestPrice {
                                Text(price)
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            } else {
                                ProgressView()
                                    .scaleEffect(0.7)
                            }
                        }
                        Divider()
                    }
                    .frame(width: 140, height: 60)
                }
            }
    }

    private func startScrolling() {
        guard !animationActive else { return }
        animationActive = true
        scrollOnce()
    }

    private func scrollOnce() {
        let duration = 30.0
        withAnimation(.linear(duration: duration)) {
            offset = -totalWidth
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            offset = 0
            scrollOnce()
        }
    }
}

