//
//  WorkoutLocalDataSourceImpl.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftData

@MainActor
struct WorkoutLocalDataSourceImpl: WorkoutLocalDataSource {
    private let modelContext = TraceLapsApp.sharedModelContainer.mainContext

    func getWorkouts() async throws -> [Workout] {
        let descriptor = FetchDescriptor<Workout>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }

    func saveWorkout(_ workout: Workout) async throws {
        modelContext.insert(workout)
        try modelContext.save()
    }
}
