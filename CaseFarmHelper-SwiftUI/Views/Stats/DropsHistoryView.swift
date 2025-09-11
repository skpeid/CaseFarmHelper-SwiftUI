//
//  DropsHistoryView.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 11.09.2025.
//

import SwiftUI

struct WeekGroup: Hashable {
    let week: Int
    let year: Int
}


struct DropsHistoryView: View {
    let drops: [Drop]
    
    var groupedByWeek: [(group: WeekGroup, drops: [Drop])] {
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
        .navigationTitle("Drops History")
    }
}
