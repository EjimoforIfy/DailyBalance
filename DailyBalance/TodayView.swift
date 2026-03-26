//
//  TodayView.swift
//  DailyBalance
//
//  Created by Ejimofor I J (FCES) on 24/03/2026.
//

import SwiftUI
import SwiftData

struct TodayView: View {

    @Environment(\.modelContext) private var context
    @Query(sort: \DayRecord.date, order: .reverse) private var records: [DayRecord]

    @State private var newMeal = ""
    @State private var showWarning = false

    // TODAY’S RECORD PROVIDER
    private var todayRecord: DayRecord {
        if let existing = records.first(where: { Calendar.current.isDateInToday($0.date) }) {
            return existing
        } else {
            let new = DayRecord()
            context.insert(new)
            try? context.save()
            return new
        }
    }

    // BODY
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                headerSection
                mealsSection
                waterSection
                stepsSection
                if showWarning { warningSection }
            }
            .padding()
        }
    }

    // HEADER
    var headerSection: some View {
        VStack(alignment: .leading) {
            Text("📅 Today")
                .font(.largeTitle.bold())
            Text(todayRecord.date.formatted(date: .complete, time: .omitted))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MEALS
    var mealsSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("🥗 Meals & Snacks")
                .font(.title2.bold())

            if todayRecord.meals.isEmpty {
                Text("No meals added yet.")
                    .foregroundColor(.secondary)
            } else {
                List(todayRecord.meals, id: \.self) { meal in
                    Text(meal)
                }
                .frame(height: 150)
            }

            HStack {
                TextField("Add new meal...", text: $newMeal)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    addMeal()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    // WATER SECTION
    var waterSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("💧 Water Intake")
                .font(.title2.bold())

            Text("\(todayRecord.waterCups) / \(todayRecord.targetWater) cups")
                .font(.headline)

            Stepper("Adjust Cups", value: Binding(
                get: { todayRecord.waterCups },
                set: {
                    todayRecord.waterCups = $0
                    try? context.save()
                }
            ), in: 0...20)

            HStack {
                Text("Set Water Target:")
                Stepper("\(todayRecord.targetWater) cups", value: Binding(
                    get: { todayRecord.targetWater },
                    set: {
                        todayRecord.targetWater = $0
                        validateTargets()
                        try? context.save()
                    }
                ), in: 2...20)
            }
        }
    }

    // STEPS SECTION
    var stepsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("👣 Steps")
                .font(.title2.bold())

            Text("\(todayRecord.steps) / \(todayRecord.targetSteps)")
                .font(.headline)
            
            // ADJUSTMENT
            Stepper("Adjust Steps", value: Binding(
                get: { todayRecord.steps },
                set: {
                    todayRecord.steps = $0
                    try? context.save()
                }
            ), in: 0...30000, step: 500)

            Button("Update from Health App") {
                StepTracker.shared.requestSteps { steps in
                    todayRecord.steps = steps
                    try? context.save()
                }
            }
            .buttonStyle(.borderedProminent)

            HStack {
                Text("Set Step Target:")
                Stepper("\(todayRecord.targetSteps)", value: Binding(
                    get: { todayRecord.targetSteps },
                    set: {
                        todayRecord.targetSteps = $0
                        validateTargets()
                        try? context.save()
                    }
                ), in: 1000...30000, step: 500)
            }
        }
    }

    // WARNING SECTION
    var warningSection: some View {
        Text("⚠️ Your target values seem unrealistic. Please adjust.")
            .foregroundColor(.red)
            .font(.footnote.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - FUNCTIONS

    func addMeal() {
        guard !newMeal.isEmpty else { return }
        todayRecord.meals.append(newMeal)
        newMeal = ""
        try? context.save()
    }

    func validateTargets() {
        if todayRecord.targetWater < 3 || todayRecord.targetWater > 15 ||
            todayRecord.targetSteps < 2000 || todayRecord.targetSteps > 20000 {
            showWarning = true
        } else {
            showWarning = false
        }
    }
}
