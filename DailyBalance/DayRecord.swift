//
//  DayRecord.swift
//  DailyBalance
//
//  Created by Ejimofor I J (FCES) on 24/03/2026.
//

import Foundation
import SwiftData

@Model
class DayRecord {
    var date: Date
    var meals: [String]
    var waterCups: Int        //  required for water tracking
    var steps: Int
    var targetWater: Int      //  required for target comparison
    var targetSteps: Int

    init(
        date: Date = Date(),
        meals: [String] = [],
        waterCups: Int = 0,
        steps: Int = 0,
        targetWater: Int = 8,
        targetSteps: Int = 8000
    ) {
        self.date = date
        self.meals = meals
        self.waterCups = waterCups
        self.steps = steps
        self.targetWater = targetWater
        self.targetSteps = targetSteps
    }
}
