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
    let date: Date
    let caseType: CSCase
    let count: Int
    
    var weekLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
}

struct DropRateGraphView: View {
    let drops: [Drop]
    
    private var chartData: [CaseRateDataPoint] {
        var data: [CaseRateDataPoint] = []
        let wednesdays = generateWeeklyWednesdays(weekCount: 4)
        
        for csCase in CSCase.activeDrop {
            let caseDrops = drops.filter { $0.caseDropped == csCase }
            let grouped = Dictionary(grouping: caseDrops) { drop in
                getWeekIndex(for: drop.date, wednesdays: wednesdays)
            }
            
            for weekIndex in 0..<4 {
                let dropsThisWeek = grouped[weekIndex] ?? []
                data.append(CaseRateDataPoint(
                    date: wednesdays[weekIndex],
                    caseType: csCase,
                    count: dropsThisWeek.count
                ))
            }
        }

        return data.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Drop Rate")
            Chart(chartData) { point in
                LineMark(
                    x: .value("Week", point.weekLabel),
                    y: .value("Count", point.count)
                )
                .foregroundStyle(by: .value("Case", point.caseType.tickerName))
                .lineStyle(StrokeStyle(lineWidth: 3))
            }
        }
        .padding()
    }
    
    private func generateWeeklyWednesdays(weekCount: Int) -> [Date] {
        let calendar = Calendar.current
        let lastReset = Date.lastResetDate
        
        var wednesdays: [Date] = []
        for i in 0..<weekCount {
            if let wednesday = calendar.date(byAdding: .weekOfYear, value: -i, to: lastReset) {
                wednesdays.append(wednesday)
            }
        }
        
        return wednesdays.reversed()
    }
    
    private func getWeekIndex(for date: Date, wednesdays: [Date]) -> Int? {
        let targetWeek = date.weekOfYear
        
        for (index, wednesday) in wednesdays.enumerated() {
            if wednesday.weekOfYear == targetWeek {
                return index
            }
        }
        return nil
    }
}
