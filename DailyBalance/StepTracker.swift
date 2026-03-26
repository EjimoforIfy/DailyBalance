//
//  StepTracker.swift
//  DailyBalance
//
//  Created by Ejimofor I J (FCES) on 24/03/2026.
//

import Foundation
import HealthKit

class StepTracker {
    static let shared = StepTracker()
    private let healthStore = HKHealthStore()

    private init() {}

    // Ask for permission to read step count from HealthKit
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(false)
            return
        }

        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, _ in
            DispatchQueue.main.async { completion(success) }
        }
    }

    // Fetch today’s total step count
    func requestSteps(completion: @escaping (Int) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(0)
            return
        }

        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(0)
            return
        }

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now)

        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            let value = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async {
                completion(Int(value))
            }
        }
        healthStore.execute(query)
    }
}

