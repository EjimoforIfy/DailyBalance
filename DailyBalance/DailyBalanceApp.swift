//
//  DailyBalanceApp.swift
//  DailyBalance
//
//  Created by Ejimofor I J (FCES) on 24/03/2026.
//

import SwiftUI
import SwiftData
import UserNotifications
@main
struct DailyBalanceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: DayRecord.self)
                .onAppear {
                    StepTracker.shared.requestAuthorization { granted in
                        if !granted {
                            print("HealthKit permission not granted.")
                        }
                    }
                }
        }
    }
}
