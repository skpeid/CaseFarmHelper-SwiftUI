//
//  DropsHistoryView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 11.09.2025.
//

import SwiftUI
import Charts

struct WeekGroup: Hashable {
    let week: Int
    let year: Int
}

struct CaseDropStat: Identifiable {
    let id = UUID()
    let caseType: CSCase
    let count: Int
}

struct DropsInfoView: View {
    let drops: [Drop]
    @State private var selectedTab = 0
    
    private var groupedDrops: [CaseDropStat] {
        Dictionary(grouping: drops, by: { $0.caseDropped })
            .map { (key, value) in
                CaseDropStat(caseType: key, count: value.count)
            }
            .sorted { $0.count > $1.count }
    }
    
    private var caseCounts: [(csCase: CSCase, count: Int)] {
        let grouped = Dictionary(grouping: drops, by: { $0.caseDropped })
        return grouped
            .map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
    }
    
    private var totalDrops: Int {
        caseCounts.reduce(0) { $0 + $1.count }
    }
    
    private var groupedByWeek: [(group: WeekGroup, drops: [Drop])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: drops) { drop in
            let week = calendar.component(.weekOfYear, from: drop.date)
            let year = calendar.component(.yearForWeekOfYear, from: drop.date)
            return WeekGroup(week: week, year: year)
        }
        return grouped
            .map { ($0.key, $0.value) }
            .sorted {
                $0.group.year == $1.group.year
                ? $0.group.week > $1.group.week
                : $0.group.year > $1.group.year
            }
    }
    
    var body: some View {
        VStack {
            ModalSheetHeaderView(title: "Drops")
                .padding()
            Picker("View Mode", selection: $selectedTab) {
                Text("Summary").tag(0)
                Text("History").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            if selectedTab == 1 {
                List {
                    ForEach(groupedByWeek, id: \.group) { group in
                        Section("Week \(group.group.week), \(group.group.year.description)") {
                            let reversed = group.drops.reversed()
                            ForEach(reversed) { drop in
                                HStack {
                                    Image(drop.caseDropped.imageName)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    VStack(alignment: .leading) {
                                        Text(drop.account.profileName)
                                        Text(drop.caseDropped.displayName)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(drop.fullDateString)
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                }
            } else {
                Chart(groupedDrops) { entry in
                    SectorMark(
                        angle: .value("Count", entry.count),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .foregroundStyle(Color.chartColor(for: entry.caseType))
                }
                .frame(height: 250)
                .overlay {
                    VStack {
                        Text("Total Drops")
                            .font(.caption)
                        Text("\(totalDrops)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .padding(.vertical)
                List(groupedDrops) { entry in
                    HStack {
                        Circle()
                            .fill(Color.chartColor(for: entry.caseType))
                            .frame(width: 16, height: 16)
                        Image(entry.caseType.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Text(entry.caseType.displayName)
                        Spacer()
                        Text("\(entry.count)  (\(percentage(for: entry.count)))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom)
                }
            }
        }
    }
    
    private func percentage(for count: Int) -> String {
        guard totalDrops > 0 else { return "0%" }
        let value = (Double(count) / Double(totalDrops)) * 100
        return String(format: "%.1f%%", value)
    }
}

