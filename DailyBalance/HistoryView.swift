//
//  HistoryView.swift
//  DailyBalance
//
//  Created by Ejimofor I J (FCES) on 24/03/2026.
//

import SwiftUI
import SwiftData
import Charts

struct HistoryView: View {
    @Query(sort: \DayRecord.date, order: .reverse) private var records: [DayRecord]
    
    var body: some View {
        VStack {
            Text("📊 Weekly Overview")
                .font(.title2)
                .padding(.top)
            
            if records.isEmpty {
                Text("No data yet. Log your first day!")
                    .foregroundStyle(.secondary)
            } else {
                Chart {
                    ForEach(records.prefix(7)) { record in
                        BarMark(
                            x: .value("Date", record.date, unit: .day),
                            y: .value("Water %", Double(record.waterCups) / Double(record.targetWater) * 100)
                        )
                        .foregroundStyle(.blue.opacity(0.8))
                        
                        LineMark(
                            x: .value("Date", record.date, unit: .day),
                            y: .value("Steps %", Double(record.steps) / Double(record.targetSteps) * 100)
                        )
                        .foregroundStyle(.green)
                    }
                }
                .frame(height: 200)
                .padding()
                Text("Blue = Water, Green Line = Steps (% of target)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            List(records) { record in
                VStack(alignment: .leading) {
                    Text(record.date, style: .date)
                        .font(.headline)
                    Text("Meals: \(record.meals.count) | Water: \(record.waterCups) | Steps: \(record.steps)")
                }
            }
        }
    }
}
