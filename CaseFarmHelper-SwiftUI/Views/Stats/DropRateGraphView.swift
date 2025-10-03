//
//  DropRateGraphView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 01.10.2025.
//

import SwiftUI
import Charts

struct CaseRateDataPoint: Identifiable {
    let id = UUID()
    let date: Date        // Store actual date
    let caseType: CSCase
    let count: Int
    
    // Computed property for display
    var day: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}

struct DropRateGraphView: View {
    let drops: [Drop]
    
    private var chartData: [CaseRateDataPoint] {
        var data: [CaseRateDataPoint] = []
        
        for csCase in CSCase.activeDrop {
            let caseDrops = drops.filter { $0.caseDropped == csCase }
            let grouped = Dictionary(grouping: caseDrops) { drop in
                Calendar.current.startOfDay(for: drop.date)
            }
            let caseData = grouped.map { date, dropsInDay in
                CaseRateDataPoint(
                    date: date,
                    caseType: csCase,
                    count: dropsInDay.count
                )
            }
            data.append(contentsOf: caseData)
        }
        
        return data.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Drop Rate")
            Chart(chartData) { point in
                LineMark(
                    x: .value("Day", point.day),
                    y: .value("Count", point.count)
                )
                .foregroundStyle(by: .value("Case", point.caseType.tickerName))
                .lineStyle(StrokeStyle(lineWidth: 3))
                
                PointMark(
                    x: .value("Day", point.day),
                    y: .value("Count", point.count)
                )
                .foregroundStyle(by: .value("Case", point.caseType.tickerName))
                .symbol(Circle())
            }
        }
        .padding()
    }
}
