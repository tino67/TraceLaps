//
//  WorkoutLocalDataSourceImpl.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftData

struct WorkoutLocalDataSourceImpl: WorkoutLocalDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    init() {
        do {
            self.modelContainer = try ModelContainer(for: Workout.self)
            self.modelContext = ModelContext(modelContainer)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func getWorkouts() async throws -> [Workout] {
        let descriptor = FetchDescriptor<Workout>()
        return try modelContext.fetch(descriptor)
    }

    func saveWorkout(_ workout: Workout) async throws {
        modelContext.insert(workout)
        try modelContext.save()
    }
}
